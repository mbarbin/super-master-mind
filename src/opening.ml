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

(* CR mbarbin: Replace by an implementation making it clear that a
   computing at depth is possible, and use it to implement compute
   with depth = 1, with the special case of the first guess being the
   canonical one.

   I propose to do this after having run through one succesful example
   of the following code first, in order to compute the dumps. *)

let compute () =
  let k = 3 in
  let possible_solutions = Permutations.all in
  let candidate = canonical_first_candidate in
  let guess = Guess.compute ~possible_solutions ~candidate in
  let by_cue =
    let number_of_cue = Array.length guess.by_cue in
    Array.mapi guess.by_cue ~f:(fun i t ->
        (* For each cue, we compute the best k candidate. *)
        print_endline (sprintf "Opening.compute: cue %d / %d" (succ i) number_of_cue);
        let possible_solutions =
          Permutations.filter possible_solutions ~candidate ~cue:t.cue
        in
        let next_best_guesses = Guess.compute_k_best ~possible_solutions ~k in
        { t with next_best_guesses = Pre_computed { next_best_guesses } })
  in
  { guess with by_cue }
;;

let dump_cmd =
  Command.basic
    ~summary:"run through an example"
    (let%map_open.Command () = return () in
     fun () ->
       let t = compute () in
       print_s [%sexp (t : t)])
;;

let cmd = Command.group ~summary:"opening pre computation" [ "dump", dump_cmd ]
