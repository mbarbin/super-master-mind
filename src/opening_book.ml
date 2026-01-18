(*********************************************************************************)
(*  super-master-mind: A solver for the super master mind game                   *)
(*  SPDX-FileCopyrightText: 2021-2025 Mathieu Barbin <mathieu.barbin@gmail.com>  *)
(*  SPDX-License-Identifier: MIT                                                 *)
(*********************************************************************************)

type t = Guess.t

let to_json = Guess.to_json
let of_json = Guess.of_json
let root t ~color_permutation = Guess.map_color t ~color_permutation

let rec compute_internal
          (t : t)
          ~display
          ~task_pool
          ~possible_solutions
          ~current_depth
          ~depth
          ~k
  =
  let number_of_cue = Nonempty_list.length t.by_cue in
  let bar =
    let open Progress.Line in
    list
      [ bar number_of_cue
      ; count_to number_of_cue
      ; parens (const "eta: " ++ eta number_of_cue)
      ]
  in
  let reporter = Progress.Display.add_line display bar in
  let by_cue =
    Nonempty_list.map t.by_cue ~f:(fun c ->
      (* For each cue, we compute the best k candidate. *)
      let possible_solutions =
        Codes.filter possible_solutions ~candidate:t.candidate ~cue:c.cue
      in
      let next_best_guesses =
        Guess.compute_k_best ~display ~task_pool ~possible_solutions ~k ()
      in
      let next_best_guesses =
        if current_depth < depth
        then
          List.map next_best_guesses ~f:(fun t ->
            compute_internal
              t
              ~display
              ~task_pool
              ~possible_solutions
              ~current_depth:(Int.succ current_depth)
              ~depth
              ~k)
        else next_best_guesses
      in
      Progress.Reporter.report reporter 1;
      { c with next_best_guesses = Computed next_best_guesses })
  in
  Progress.Reporter.finalise reporter;
  Progress.Display.remove_line display reporter;
  { t with by_cue }
;;

let canonical_first_candidate =
  lazy
    (Array.init (Lazy.force Code.size) ~f:Fun.id
     |> Array.map ~f:Color.of_index_exn
     |> Array.map ~f:Color.to_hum
     |> Code.create_exn)
;;

let compute ~task_pool ~depth =
  if depth < 1 then Code_error.raise "depth >= 1 expected." [ "depth", Dyn.int depth ];
  let display =
    Progress.Display.start
      ~config:(Progress.Config.v ~persistent:false ())
      (Progress.Multi.lines [])
  in
  let possible_solutions = Codes.all in
  let t =
    Guess.compute ~possible_solutions ~candidate:(Lazy.force canonical_first_candidate)
  in
  let t =
    compute_internal
      t
      ~display
      ~task_pool
      ~possible_solutions
      ~current_depth:1
      ~depth
      ~k:1
  in
  Progress.Display.finalise display;
  t
;;

let depth =
  let rec aux (t : Guess.t) =
    Nonempty_list.fold t.by_cue ~init:0 ~f:(fun acc t -> Int.max acc (aux_by_cue t))
  and aux_by_cue (t : Guess.By_cue.t) =
    match t.next_best_guesses with
    | Not_computed -> 0
    | Computed ts -> 1 + List.fold ts ~init:0 ~f:(fun acc t -> Int.max acc (aux t))
  in
  aux
;;

let find_opening_book_via_site () =
  List.find_map Sites.Sites.opening_book ~f:(fun dir ->
    let file = Stdlib.Filename.concat dir "opening-book.json" in
    Option.some_if (Stdlib.Sys.file_exists file) file)
;;

let opening_book =
  lazy
    (let file = find_opening_book_via_site () |> Option.get in
     Json.load ~file |> of_json)
;;

let dump_cmd =
  Command.make
    ~summary:"Dump the installed opening-book."
    (let open Command.Std in
     let+ () = Arg.return () in
     let t = Lazy.force opening_book in
     Stdlib.print_endline (t |> to_json |> Json.to_string))
;;

let compute_cmd =
  Command.make
    ~summary:"Compute and save the opening-book."
    (let open Command.Std in
     let+ () = Game_dimensions.arg (Source_code_position.of_pos Stdlib.__POS__)
     and+ depth =
       Arg.named_with_default
         [ "depth" ]
         Param.int
         ~default:2
         ~doc:"Specify the depth of the opening-book."
     and+ task_pool_config = Task_pool.Config.arg
     and+ path =
       Arg.named
         [ "output-file"; "o" ]
         Param.string
         ~docv:"FILE"
         ~doc:"Save output to file."
     in
     Task_pool.with_t task_pool_config ~f:(fun ~task_pool ->
       let t = compute ~task_pool ~depth in
       Json.save (to_json t) ~file:path))
;;

let verify_cmd =
  Command.make
    ~summary:"Verify properties of the installed opening-book."
    (let open Command.Std in
     let+ color_permutation =
       let+ v =
         Arg.named_opt
           [ "color-permutation" ]
           Color_permutation.param
           ~doc:"Color permutation in [0; 40319] (default Identity)."
       in
       match v with
       | Some color_permutation -> color_permutation
       | None -> Lazy.force Color_permutation.identity
     in
     let t = root (Lazy.force opening_book) ~color_permutation in
     match Guess.verify t ~possible_solutions:Codes.all with
     | Ok () -> ()
     | Error error ->
       Stdlib.prerr_endline "Installed opening-book does not verify expected properties.";
       Guess.Verify_error.print_hum error Out_channel.stderr;
       Stdlib.exit 1)
;;

let cmd =
  Command.group
    ~summary:"Opening pre computation (aka the 'opening-book')."
    [ "dump", dump_cmd; "compute", compute_cmd; "verify", verify_cmd ]
;;
