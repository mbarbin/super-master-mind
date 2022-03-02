open! Core

module By_cue = struct
  type t =
    { cue : Cue.t
    ; size_remaining : int
    ; bits_remaining : float
    ; probability : float
    }
  [@@deriving equal, sexp_of]
end

type t =
  { candidate : Permutation.t
  ; expected_bits : float
  ; by_cue : By_cue.t array (* Sorted by decreasing number of remaining sizes *)
  }
[@@deriving equal, sexp_of]

let compute ~cache ~possible_solutions ~candidate : t =
  let original_size = Float.of_int (Permutations.size possible_solutions) in
  let by_cue =
    let by_cue = Array.init Cue.cardinality ~f:(fun _ -> Queue.create ()) in
    Permutations.iter possible_solutions ~f:(fun solution ->
        let cue = Permutation.analyse ~cache ~solution ~candidate in
        Queue.enqueue by_cue.(Cue.to_index cue) solution);
    let by_cue =
      Array.filter_mapi by_cue ~f:(fun i remains ->
          let size_remaining = Queue.length remains in
          if size_remaining > 0
          then
            Some
              { By_cue.cue = Cue.of_index_exn i
              ; size_remaining
              ; bits_remaining = Permutation.Private.log2 (Float.of_int size_remaining)
              ; probability = Float.of_int size_remaining /. original_size
              }
          else None)
    in
    Array.sort by_cue ~compare:(fun t1 t2 ->
        Int.compare t2.size_remaining t1.size_remaining);
    by_cue
  in
  let expected_bits =
    Array.fold by_cue ~init:0. ~f:(fun acc t ->
        let p = t.probability in
        acc +. (-1. *. p *. Permutation.Private.log2 p))
  in
  { candidate; expected_bits; by_cue }
;;

let do_ansi f = if ANSITerminal.isatty.contents Core_unix.stdout then f ()

let compute_k_best ~cache ~possible_solutions ~k =
  let ts =
    Kheap.create ~k ~compare:(fun (t1 : t) t2 ->
        Float.compare t2.expected_bits t1.expected_bits)
  in
  for candidate = 0 to Permutation.cardinality - 1 do
    do_ansi (fun () ->
        ANSITerminal.move_bol ();
        ANSITerminal.print_string
          []
          (sprintf
             "Permutation.step_candidate : %d / %d"
             (succ candidate)
             (Permutation.cardinality - 1)));
    let t =
      compute ~cache ~possible_solutions ~candidate:(Permutation.of_index_exn candidate)
    in
    if Float.( > ) t.expected_bits 0. then Kheap.add ts t
  done;
  do_ansi (fun () ->
      ANSITerminal.move_bol ();
      ANSITerminal.erase Eol);
  Kheap.to_list ts
;;
