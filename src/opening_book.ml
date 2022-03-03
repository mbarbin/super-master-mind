open! Core
open! Import

let canonical_first_candidate =
  Array.init Permutation.size ~f:Fn.id
  |> Array.map ~f:Color.of_index_exn
  |> Array.map ~f:Color.to_hum
  |> Permutation.create_exn
;;

type t = Guess.t [@@deriving sexp]

let root t = t
let do_ansi f = if ANSITerminal.isatty.contents Core_unix.stdout then f ()

let rec compute_internal (t : t) ~possible_solutions ~current_depth ~depth ~k =
  let number_of_cue = Nonempty_list.length t.by_cue in
  let i = ref 0 in
  Nonempty_list.iter t.by_cue ~f:(fun c ->
      let i =
        incr i;
        !i
      in
      (* For each cue, we compute the best k candidate. *)
      do_ansi (fun () ->
          print_endline
            (sprintf
               "Opening.compute[depth:%d]: cue %d / %d"
               current_depth
               i
               number_of_cue));
      let possible_solutions =
        Permutations.filter possible_solutions ~candidate:t.candidate ~cue:c.cue
      in
      let next_best_guesses = Guess.compute_k_best ~possible_solutions ~k in
      c.next_best_guesses <- Computed next_best_guesses;
      if current_depth < depth
      then
        List.iter next_best_guesses ~f:(fun t ->
            compute_internal
              t
              ~possible_solutions
              ~current_depth:(succ current_depth)
              ~depth
              ~k))
;;

let compute ~depth =
  if depth < 1 then raise_s [%sexp "depth >= 1 expected", [%here], { depth : int }];
  let possible_solutions = Permutations.all in
  let t = Guess.compute ~possible_solutions ~candidate:canonical_first_candidate in
  compute_internal t ~possible_solutions ~current_depth:1 ~depth ~k:1;
  t
;;

let opening_book =
  lazy (Sexp.of_string_conv_exn Embedded_files.opening_book_dot_expected [%of_sexp: t])
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
    ~summary:"compute and dump opening book"
    (let%map_open.Command depth =
       flag "--depth" (optional_with_default 1 int) ~doc:"INT depth of book (default 1)"
     in
     fun () ->
       let t = compute ~depth in
       print_s [%sexp (t : t)])
;;

let cmd =
  Command.group
    ~summary:"opening pre computation"
    [ "dump", dump_cmd; "compute", compute_cmd ]
;;
