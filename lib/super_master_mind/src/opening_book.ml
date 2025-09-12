(*********************************************************************************)
(*  super-master-mind: A solver for the super master mind game                   *)
(*  SPDX-FileCopyrightText: 2021-2025 Mathieu Barbin <mathieu.barbin@gmail.com>  *)
(*  SPDX-License-Identifier: MIT                                                 *)
(*********************************************************************************)

type t = Guess.t [@@deriving sexp]

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
    (Array.init (force Code.size) ~f:Fn.id
     |> Array.map ~f:Color.of_index_exn
     |> Array.map ~f:Color.to_hum
     |> Code.create_exn)
;;

let compute ~task_pool ~depth =
  if depth < 1 then raise_s [%sexp "depth >= 1 expected", [%here], { depth : int }];
  let display =
    Progress.Display.start
      ~config:(Progress.Config.v ~persistent:false ())
      (Progress.Multi.lines [])
  in
  let possible_solutions = Codes.all in
  let t =
    Guess.compute ~possible_solutions ~candidate:(force canonical_first_candidate)
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

let opening_book =
  lazy
    (Parsexp.Single.parse_string_exn Embedded_files.opening_book_dot_expected
     |> [%of_sexp: t])
;;

let dump_cmd =
  Command.make
    ~summary:"Dump the embedded opening-book."
    (let open Command.Std in
     let+ () = Arg.return () in
     let t = Lazy.force opening_book in
     print_s [%sexp (t : t)])
;;

let compute_cmd =
  Command.make
    ~summary:"Compute and save the opening-book."
    (let open Command.Std in
     let+ () = Game_dimensions.arg [%here]
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
       Out_channel.with_file path ~f:(fun oc ->
         Out_channel.output_string oc (Sexp.to_string_hum [%sexp (t : t)]);
         Out_channel.output_char oc '\n')))
;;

let verify_cmd =
  Command.make
    ~summary:"Verify properties of the embedded opening-book."
    (let open Command.Std in
     let+ color_permutation =
       match%map.Command
         Arg.named_opt
           [ "color-permutation" ]
           Color_permutation.param
           ~doc:"Color permutation in [0; 40319] (default Identity)."
       with
       | Some color_permutation -> color_permutation
       | None -> force Color_permutation.identity
     in
     let t = root (Lazy.force opening_book) ~color_permutation in
     match Guess.verify t ~possible_solutions:Codes.all with
     | Ok () -> ()
     | Error error ->
       prerr_endline "Embedded opening-book does not verify expected properties.";
       Guess.Verify_error.print_hum ~color:true error Out_channel.stderr;
       Stdlib.exit 1)
;;

let cmd =
  Command.group
    ~summary:"Opening pre computation (aka the 'opening-book')."
    [ "dump", dump_cmd; "compute", compute_cmd; "verify", verify_cmd ]
;;
