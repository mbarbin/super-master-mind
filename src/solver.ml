open! Core

let input_line () = Stdio.In_channel.(input_line_exn stdin)

let rec input_cue () =
  let rec input_int ~prompt =
    print_string prompt;
    Stdio.Out_channel.(flush stdout);
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

let solve () =
  let color_permutation =
    Color_permutation.of_index_exn (Random.int Color_permutation.cardinality)
  in
  if not (ANSITerminal.isatty.contents Core_unix.stdin)
  then raise_s [%sexp "Solver expected to run in a terminal with user input"];
  print_string "Press enter when done choosing a solution: ";
  Stdio.Out_channel.(flush stdout);
  let (_ : string) = input_line () in
  let step_index = ref 0 in
  let print (t : Guess.t) =
    incr step_index;
    print_s [%sexp (!step_index : int), (t.candidate : Code.t)];
    Stdio.Out_channel.(flush stdout)
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
      match by_cue.next_best_guesses with
      | Computed [] -> ()
      | Computed (guess :: _) -> aux guess ~possible_solutions
      | Not_computed ->
        (match Guess.compute_k_best ~possible_solutions ~k:1 with
         | [] -> ()
         | guess :: _ -> aux guess ~possible_solutions))
  in
  let opening_book = Lazy.force Opening_book.opening_book in
  let root = Opening_book.root opening_book ~color_permutation in
  aux root ~possible_solutions:Codes.all
;;

let cmd =
  Command.basic
    ~summary:"solve interactively"
    (let%map_open.Command () = return () in
     fun () -> solve ())
;;
