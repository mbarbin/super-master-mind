open! Core
open! Import

let canonical_first_candidate =
  Array.init Permutation.size ~f:Fn.id
  |> Array.map ~f:Color.of_index_exn
  |> Array.map ~f:Color.to_hum
  |> Permutation.create_exn
;;

module By_cue = struct
  type t =
    { guess_cue : Guess.By_cue.t
    ; best_guesses : Guess.t list (* Sorted best guesses first *)
    }
  [@@deriving sexp_of]
end

type t =
  { candidate : Permutation.t
  ; expected_bits_gained : float
  ; by_cue : By_cue.t array (* Sorted by decreasing number of remaining sizes *)
  }
[@@deriving sexp_of]

let do_ansi f = if ANSITerminal.isatty.contents Core_unix.stdout then f ()

let compute () =
  let k = 3 in
  let cache = Permutation.Cache.create () in
  let possible_solutions = Permutations.all in
  let candidate = canonical_first_candidate in
  let guess = Guess.compute ~cache ~possible_solutions ~candidate in
  let by_cue =
    let number_of_cue = Array.length guess.by_cue in
    Array.mapi guess.by_cue ~f:(fun i t ->
        (* For each cue, we compute the best k candidate. *)
        print_endline (sprintf "Opening.compute: cue %d / %d" (succ i) number_of_cue);
        let possible_solutions =
          Permutations.filter possible_solutions ~cache ~candidate ~cue:t.cue
        in
        let best_guesses = Guess.compute_k_best ~cache ~possible_solutions ~k in
        { By_cue.guess_cue = t; best_guesses })
  in
  { candidate; expected_bits_gained = guess.expected_bits_gained; by_cue }
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
