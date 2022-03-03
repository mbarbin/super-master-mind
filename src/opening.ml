open! Core
open! Import

let canonical_first_candidate =
  Array.init Permutation.size ~f:Fn.id
  |> Array.map ~f:Color.of_index_exn
  |> Array.map ~f:Color.to_hum
  |> Permutation.create_exn
;;

type t = Guess.t [@@deriving sexp_of]

let do_ansi f = if ANSITerminal.isatty.contents Core_unix.stdout then f ()

let rec compute_internal (t : t) ~possible_solutions ~depth ~max_depth ~k =
  let number_of_cue = Array.length t.by_cue in
  Array.iteri t.by_cue ~f:(fun i c ->
      (* For each cue, we compute the best k candidate. *)
      print_endline
        (sprintf "Opening.compute[depth:%d]: cue %d / %d" depth (succ i) number_of_cue);
      let possible_solutions =
        Permutations.filter possible_solutions ~candidate:t.candidate ~cue:c.cue
      in
      let next_best_guesses = Guess.compute_k_best ~possible_solutions ~k in
      c.next_best_guesses <- Computed next_best_guesses;
      if depth < max_depth
      then
        List.iter next_best_guesses ~f:(fun t ->
            compute_internal t ~possible_solutions ~depth:(succ depth) ~max_depth ~k))
;;

let compute () =
  let possible_solutions = Permutations.all in
  let t = Guess.compute ~possible_solutions ~candidate:canonical_first_candidate in
  compute_internal t ~possible_solutions ~depth:1 ~max_depth:1 ~k:1;
  t
;;

(* CR mbarbin: Replace by an actual load command once the sexp is in
   place and can be parsed. *)
let () = ignore Embedded_files.opening_book_dot_expected

let dump_cmd =
  Command.basic
    ~summary:"run through an example"
    (let%map_open.Command () = return () in
     fun () ->
       let t = compute () in
       print_s [%sexp (t : t)])
;;

let cmd = Command.group ~summary:"opening pre computation" [ "dump", dump_cmd ]
