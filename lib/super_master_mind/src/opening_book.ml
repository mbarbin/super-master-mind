type t = Guess.t [@@deriving sexp]

let root t ~color_permutation = Guess.map_color t ~color_permutation
let do_ansi f = if Stdlib.Out_channel.isatty Out_channel.stdout then f ()

let rec compute_internal (t : t) ~task_pool ~possible_solutions ~current_depth ~depth ~k =
  let number_of_cue = Nonempty_list.length t.by_cue in
  let by_cue =
    Nonempty_list.mapi t.by_cue ~f:(fun i c ->
      (* For each cue, we compute the best k candidate. *)
      do_ansi (fun () ->
        print_endline
          (Printf.sprintf
             "Opening.compute[depth:%d]: cue %d / %d"
             current_depth
             (Int.succ i)
             number_of_cue));
      let possible_solutions =
        Codes.filter possible_solutions ~candidate:t.candidate ~cue:c.cue
      in
      let next_best_guesses = Guess.compute_k_best ~task_pool ~possible_solutions ~k in
      let next_best_guesses =
        if current_depth < depth
        then
          List.map next_best_guesses ~f:(fun t ->
            compute_internal
              t
              ~task_pool
              ~possible_solutions
              ~current_depth:(Int.succ current_depth)
              ~depth
              ~k)
        else next_best_guesses
      in
      { c with next_best_guesses = Computed next_best_guesses })
  in
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
  let possible_solutions = Codes.all in
  let t =
    Guess.compute ~possible_solutions ~candidate:(force canonical_first_candidate)
  in
  compute_internal t ~task_pool ~possible_solutions ~current_depth:1 ~depth ~k:1
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
  Command.basic
    ~summary:"dump embedded opening-book"
    (let%map_open.Command () = return () in
     fun () ->
       let t = Lazy.force opening_book in
       print_s [%sexp (t : t)])
;;

let compute_cmd =
  Command.basic
    ~summary:"compute and save opening book"
    (let%map_open.Command () = Game_dimensions.param [%here]
     and depth =
       flag "--depth" (optional_with_default 2 int) ~doc:"INT depth of book (default 2)"
     and task_pool_config = Task_pool.Config.param
     and filename =
       flag
         "--output-file"
         ~aliases:[ "o" ]
         (required string)
         ~doc:"FILE save output to file"
     in
     fun () ->
       Task_pool.with_t task_pool_config ~f:(fun ~task_pool ->
         let t = compute ~task_pool ~depth in
         Out_channel.with_file filename ~f:(fun oc ->
           Out_channel.output_string oc (Sexp.to_string_hum [%sexp (t : t)]);
           Out_channel.output_char oc '\n')))
;;

let verify_cmd =
  Command.basic
    ~summary:"verify properties of embedded opening book"
    (let%map_open.Command color_permutation =
       flag
         "--color-permutation"
         (optional_with_default 0 int)
         ~doc:"INT color permutation in [0; 40319] (default Identity)"
       >>| Color_permutation.of_index_exn
     in
     fun () ->
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
    ~summary:"opening pre computation"
    [ "dump", dump_cmd; "compute", compute_cmd; "verify", verify_cmd ]
;;
