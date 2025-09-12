(*********************************************************************************)
(*  super-master-mind: A solver for the super master mind game                   *)
(*  SPDX-FileCopyrightText: 2021-2025 Mathieu Barbin <mathieu.barbin@gmail.com>  *)
(*  SPDX-License-Identifier: MIT                                                 *)
(*********************************************************************************)

let input_line () = In_channel.(input_line_exn stdin)

let rec input_cue () =
  let rec input_int ~prompt =
    print_string prompt;
    Out_channel.(flush stdout);
    let int = input_line () in
    match Int.of_string int with
    | exception e ->
      print_s [%sexp (e : Exn.t)];
      input_int ~prompt
    | i -> i
  in
  let black = input_int ~prompt:"#black (correctly placed)  : " in
  let white =
    let prompt = "#white (incorrectly placed): " in
    if black >= 4
    then (
      print_endline (prompt ^ "0");
      0)
    else input_int ~prompt
  in
  match Cue.create_exn { white; black } with
  | exception e ->
    print_s [%sexp (e : Exn.t)];
    input_cue ()
  | cue -> cue
;;

let solve ~color_permutation ~task_pool =
  print_string "Press enter when done choosing a solution: ";
  Out_channel.(flush stdout);
  let (_ : string) = input_line () in
  let step_index = ref 0 in
  let print (t : Guess.t) =
    Int.incr step_index;
    print_s [%sexp (!step_index : int), (t.candidate : Code.t)];
    Out_channel.(flush stdout)
  in
  let rec aux (t : Guess.t) ~possible_solutions =
    print t;
    let cue = input_cue () in
    let by_cue =
      Nonempty_list.find t.by_cue ~f:(fun by_cue -> Cue.equal cue by_cue.cue)
      |> Option.value_exn ~here:[%here]
    in
    let possible_solutions =
      Codes.filter possible_solutions ~candidate:t.candidate ~cue
    in
    if Codes.size possible_solutions = 1
    then (
      let solution = List.hd_exn (Codes.to_list possible_solutions) in
      let guess = Guess.compute ~possible_solutions ~candidate:solution in
      print guess)
    else (
      let guess =
        match by_cue.next_best_guesses with
        | Computed [] -> assert false
        | Computed (guess :: _) -> guess
        | Not_computed ->
          (match Guess.compute_k_best ~task_pool ~possible_solutions ~k:1 () with
           | [] -> assert false
           | guess :: _ -> guess)
      in
      aux guess ~possible_solutions)
  in
  let opening_book = Lazy.force Opening_book.opening_book in
  let root = Opening_book.root opening_book ~color_permutation in
  aux root ~possible_solutions:Codes.all
;;

let cmd =
  Command.make
    ~summary:"Solve interactively."
    (let open Command.Std in
     let+ color_permutation =
       Arg.named_opt
         [ "color-permutation" ]
         Param.int
         ~docv:"N"
         ~doc:"Force use of permutation (random by default)."
     and+ task_pool_config = Task_pool.Config.arg in
     let color_permutation =
       let index =
         match color_permutation with
         | Some index -> index
         | None -> Random.int (force Color_permutation.cardinality) [@coverage off]
       in
       Color_permutation.of_index_exn index
     in
     Task_pool.with_t task_pool_config ~f:(fun ~task_pool ->
       solve ~color_permutation ~task_pool))
;;
