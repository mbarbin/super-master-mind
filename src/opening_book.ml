open! Core
open! Import

let canonical_first_candidate =
  Array.init Code.size ~f:Fn.id
  |> Array.map ~f:Color.of_index_exn
  |> Array.map ~f:Color.to_hum
  |> Code.create_exn
;;

type t = Guess.t [@@deriving sexp]

let root t ~color_permutation = Guess.map_color t ~color_permutation
let do_ansi f = if ANSITerminal.isatty.contents Core_unix.stdout then f ()

let rec compute_internal (t : t) ~possible_solutions ~current_depth ~depth ~k =
  let number_of_cue = Nonempty_list.length t.by_cue in
  let by_cue =
    Nonempty_list.mapi t.by_cue ~f:(fun i c ->
        (* For each cue, we compute the best k candidate. *)
        do_ansi (fun () ->
            print_endline
              (sprintf
                 "Opening.compute[depth:%d]: cue %d / %d"
                 current_depth
                 (succ i)
                 number_of_cue));
        let possible_solutions =
          Codes.filter possible_solutions ~candidate:t.candidate ~cue:c.cue
        in
        let next_best_guesses = Guess.compute_k_best ~possible_solutions ~k in
        let next_best_guesses =
          if current_depth < depth
          then
            List.map next_best_guesses ~f:(fun t ->
                compute_internal
                  t
                  ~possible_solutions
                  ~current_depth:(succ current_depth)
                  ~depth
                  ~k)
          else next_best_guesses
        in
        { c with next_best_guesses = Computed next_best_guesses })
  in
  { t with by_cue }
;;

let compute_with_candidate ~candidate ~depth =
  if depth < 1 then raise_s [%sexp "depth >= 1 expected", [%here], { depth : int }];
  let possible_solutions = Codes.all in
  let t = Guess.compute ~possible_solutions ~candidate in
  compute_internal t ~possible_solutions ~current_depth:1 ~depth ~k:1
;;

let compute ~depth = compute_with_candidate ~candidate:canonical_first_candidate ~depth

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
       flag "--depth" (optional_with_default 2 int) ~doc:"INT depth of book (default 2)"
     in
     fun () ->
       let t = compute ~depth in
       print_s [%sexp (t : t)])
;;

let verify_cmd =
  Command.basic
    ~summary:"recompute and compare with embedded opening book"
    (let%map_open.Command () = return () in
     fun () ->
       let t = Lazy.force opening_book in
       let depth = depth t in
       let t' = compute ~depth in
       if not (Guess.equal t t')
       then raise_s [%sexp "Embedded opening-book differs when recomputed"])
;;

let test_color_permutation_cmd =
  Command.basic
    ~summary:"recompute and verify color permutation"
    (let%map_open.Command color_permutation =
       flag
         "--color-permutation"
         (optional_with_default 40319 int)
         ~doc:"INT color permutation in [0; 40319] (default MAX)"
       >>| Color_permutation.of_index_exn
     in
     fun () ->
       let t = root (Lazy.force opening_book) ~color_permutation in
       let depth = depth t in
       let t' =
         compute_with_candidate
           ~candidate:(Code.map_color canonical_first_candidate ~color_permutation)
           ~depth
       in
       if not (Guess.equal t t')
       then (
         print_endline "Color permutation differs when recomputed";
         let mapped = Filename_unix.temp_file "opening-book" "mapped" in
         let computed = Filename_unix.temp_file "opening-book" "computed" in
         Sexp.save_hum mapped [%sexp (t : Guess.t)];
         Sexp.save_hum computed [%sexp (t' : Guess.t)];
         print_endline (sprintf "Sexps saved as:");
         print_endline ("  - " ^ mapped);
         print_endline ("  - " ^ computed);
         raise_s [%sexp "Unexpected diffs"]))
;;

let cmd =
  Command.group
    ~summary:"opening pre computation"
    [ "dump", dump_cmd
    ; "compute", compute_cmd
    ; "test-color-permutation", test_color_permutation_cmd
    ; "verify", verify_cmd
    ]
;;
