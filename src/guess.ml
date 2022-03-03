open! Core
open! Import

module rec By_cue : sig
  type t =
    { cue : Cue.t
    ; size_remaining : int
    ; bits_remaining : float
    ; bits_gained : float
    ; probability : float
    }
  [@@deriving equal, sexp_of]
end = struct
  type t =
    { cue : Cue.t
    ; size_remaining : int
    ; bits_remaining : float
    ; bits_gained : float
    ; probability : float
    }
  [@@deriving equal, sexp_of]
end

and T : sig
  type t =
    { candidate : Permutation.t
    ; expected_bits_gained : float
    ; expected_bits_remaining : float
    ; min_bits_gained : float
    ; max_bits_gained : float
    ; max_bits_remaining : float
    ; by_cue : By_cue.t array (* Sorted by decreasing number of remaining sizes *)
    }
  [@@deriving equal, sexp_of]
end = struct
  type t =
    { candidate : Permutation.t
    ; expected_bits_gained : float
    ; expected_bits_remaining : float
    ; min_bits_gained : float
    ; max_bits_gained : float
    ; max_bits_remaining : float
    ; by_cue : By_cue.t array (* Sorted by decreasing number of remaining sizes *)
    }
  [@@deriving equal, sexp_of]
end

include T

let compute ~cache ~possible_solutions ~candidate : t =
  let original_size = Float.of_int (Permutations.size possible_solutions) in
  let original_bits = Float.log2 original_size in
  let by_cue =
    let by_cue = Array.init Cue.cardinality ~f:(fun _ -> Queue.create ()) in
    Permutations.iter possible_solutions ~f:(fun solution ->
        let cue = Permutation.analyse ~cache ~solution ~candidate in
        Queue.enqueue by_cue.(Cue.to_index cue) solution);
    let by_cue =
      Array.filter_mapi by_cue ~f:(fun i remains ->
          let size_remaining = Queue.length remains in
          if size_remaining > 0
          then (
            let bits_remaining = Float.log2 (Float.of_int size_remaining) in
            Some
              { By_cue.cue = Cue.of_index_exn i
              ; size_remaining
              ; bits_remaining
              ; bits_gained = original_bits -. bits_remaining
              ; probability = Float.of_int size_remaining /. original_size
              })
          else None)
    in
    Array.sort by_cue ~compare:(fun t1 t2 ->
        Int.compare t2.size_remaining t1.size_remaining);
    by_cue
  in
  let min_bits_gained =
    Array.fold by_cue ~init:Float.infinity ~f:(fun acc t -> Float.min acc t.bits_gained)
  in
  let max_bits_gained =
    Array.fold by_cue ~init:0. ~f:(fun acc t -> Float.max acc t.bits_gained)
  in
  let expected_bits_gained =
    Array.fold by_cue ~init:0. ~f:(fun acc t -> acc +. (t.probability *. t.bits_gained))
  in
  let expected_bits_remaining = original_bits -. expected_bits_gained in
  { candidate
  ; expected_bits_gained
  ; expected_bits_remaining
  ; min_bits_gained
  ; max_bits_gained
  ; max_bits_remaining = original_bits -. min_bits_gained
  ; by_cue
  }
;;

let do_ansi f = if ANSITerminal.isatty.contents Core_unix.stdout then f ()

let compute_k_best ~cache ~possible_solutions ~k =
  let ts =
    Kheap.create ~k ~compare:(fun (t1 : t) t2 ->
        Float.compare t2.expected_bits_gained t1.expected_bits_gained)
  in
  for candidate = 0 to Permutation.cardinality - 1 do
    do_ansi (fun () ->
        ANSITerminal.move_bol ();
        ANSITerminal.print_string
          []
          (sprintf
             "Guess.compute_k_best : %d / %d"
             (succ candidate)
             (Permutation.cardinality - 1)));
    let t =
      compute ~cache ~possible_solutions ~candidate:(Permutation.of_index_exn candidate)
    in
    if Float.( > ) t.expected_bits_gained 0. then Kheap.add ts t
  done;
  do_ansi (fun () ->
      ANSITerminal.move_bol ();
      ANSITerminal.erase Eol);
  Kheap.to_list ts
;;
