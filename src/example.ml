open! Core
open! Import

let solve ~solution =
  let steps = Queue.create () in
  let step_index = ref 0 in
  let add (t : Guess.t) ~by_cue =
    let by_cue =
      Nonempty_list.singleton
        { by_cue with Guess.By_cue.next_best_guesses = Not_computed }
    in
    let t = { t with by_cue } in
    Queue.enqueue steps t;
    incr step_index;
    print_s [%sexp (!step_index : int), (t : Guess.t)]
  in
  let rec aux (t : Guess.t) ~possible_solutions =
    let cue = Permutation.analyse ~solution ~candidate:t.candidate in
    let by_cue =
      Nonempty_list.find t.by_cue ~f:(fun by_cue -> Cue.equal cue by_cue.cue)
      |> Option.value_exn ~here:[%here]
    in
    add t ~by_cue;
    let possible_solutions =
      Permutations.filter possible_solutions ~candidate:t.candidate ~cue
    in
    if Permutations.size possible_solutions = 1
    then (
      let solution = List.hd_exn (Permutations.to_list possible_solutions) in
      let guess = Guess.compute ~possible_solutions ~candidate:solution in
      add guess ~by_cue:(Nonempty_list.hd guess.by_cue))
    else (
      match by_cue.next_best_guesses with
      | Computed [] -> ()
      | Computed (guess :: _) -> aux guess ~possible_solutions
      | Not_computed ->
        (match Guess.compute_k_best ~possible_solutions ~k:1 with
        | [] -> ()
        | guess :: _ -> aux guess ~possible_solutions))
  in
  let opening_book = Lazy.force Opening_book.opening_book in
  let root = Opening_book.root opening_book in
  aux root ~possible_solutions:Permutations.all;
  Queue.to_list steps
;;

let cmd =
  Command.basic
    ~summary:"run through an example"
    (let%map_open.Command () = return () in
     fun () ->
       let solution = Permutation.create_exn [| Green; Blue; Orange; White; Red |] in
       ignore (solve ~solution : Guess.t list))
;;
