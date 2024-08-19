let solve ~task_pool ~color_permutation ~solution =
  let steps = Queue.create () in
  let step_index = ref 0 in
  let add (t : Guess.t) ~by_cue =
    let by_cue =
      Nonempty_list.singleton
        { by_cue with Guess.By_cue.next_best_guesses = Not_computed }
    in
    let t = { t with by_cue } in
    Queue.enqueue steps t;
    Int.incr step_index;
    print_s [%sexp (!step_index : int), (t : Guess.t)]
  in
  let rec aux (t : Guess.t) ~possible_solutions =
    let cue = Code.analyze ~solution ~candidate:t.candidate in
    let by_cue =
      Nonempty_list.find t.by_cue ~f:(fun by_cue -> Cue.equal cue by_cue.cue)
      |> Option.value_exn ~here:[%here]
    in
    add t ~by_cue;
    let possible_solutions =
      Codes.filter possible_solutions ~candidate:t.candidate ~cue
    in
    if Codes.size possible_solutions = 1
    then (
      let solution = List.hd_exn (Codes.to_list possible_solutions) in
      let guess = Guess.compute ~possible_solutions ~candidate:solution in
      add guess ~by_cue:(Nonempty_list.hd guess.by_cue))
    else (
      match by_cue.next_best_guesses with
      | Computed [] -> ()
      | Computed (guess :: _) -> aux guess ~possible_solutions
      | Not_computed ->
        (match Guess.compute_k_best ~task_pool ~possible_solutions ~k:1 () with
         | [] -> ()
         | guess :: _ -> aux guess ~possible_solutions))
  in
  let opening_book = Lazy.force Opening_book.opening_book in
  let root =
    Opening_book.root opening_book ~color_permutation:(force color_permutation)
  in
  aux root ~possible_solutions:Codes.all;
  Queue.to_list steps
;;

let cmd =
  Command.make
    ~summary:"run through an example"
    (let%map_open.Command solution =
       Arg.named_opt
         [ "solution" ]
         Code.param
         ~doc:"CODE chosen solution (default is arbitrary)"
     and task_pool_config = Task_pool.Config.arg in
     Task_pool.with_t task_pool_config ~f:(fun ~task_pool ->
       let solution =
         match solution with
         | Some solution -> solution
         | None -> Code.create_exn [| Green; Blue; Orange; White; Red |]
       in
       ignore
         (solve ~task_pool ~color_permutation:Color_permutation.identity ~solution
          : Guess.t list)))
;;
