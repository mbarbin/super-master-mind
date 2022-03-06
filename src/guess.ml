open! Core
open! Import

module rec Next_best_guesses : sig
  (* When computed, best guesses are sorted by decreasing number of
     expected_bits_gained. *)
  type t =
    | Not_computed
    | Computed of T.t list
  [@@deriving equal, sexp]
end = struct
  type t =
    | Not_computed
    | Computed of T.t list
  [@@deriving equal, sexp]
end

and By_cue : sig
  type t =
    { cue : Cue.t
    ; size_remaining : int
    ; bits_remaining : float
    ; bits_gained : float
    ; probability : float
    ; mutable next_best_guesses : Next_best_guesses.t
    }
  [@@deriving equal, sexp]
end = struct
  type t =
    { cue : Cue.t
    ; size_remaining : int
    ; bits_remaining : float
    ; bits_gained : float
    ; probability : float
    ; mutable next_best_guesses : Next_best_guesses.t
    }
  [@@deriving equal, sexp]
end

and T : sig
  type t =
    { candidate : Permutation.t
    ; expected_bits_gained : float
    ; expected_bits_remaining : float
    ; min_bits_gained : float
    ; max_bits_gained : float
    ; max_bits_remaining : float
    ; by_cue :
        By_cue.t Nonempty_list.t (* Sorted by decreasing number of remaining sizes *)
    }
  [@@deriving equal, sexp]
end = struct
  type t =
    { candidate : Permutation.t
    ; expected_bits_gained : float
    ; expected_bits_remaining : float
    ; min_bits_gained : float
    ; max_bits_gained : float
    ; max_bits_remaining : float
    ; by_cue : By_cue.t Nonempty_list.t
    }
  [@@deriving equal, sexp]
end

include T

let compute ~possible_solutions ~candidate : t =
  if Permutations.is_empty possible_solutions
  then raise_s [%sexp "No possible solutions", [%here]];
  let original_size = Float.of_int (Permutations.size possible_solutions) in
  let original_bits = Float.log2 original_size in
  let by_cue =
    let by_cue = Array.init Cue.cardinality ~f:(fun _ -> Queue.create ()) in
    Permutations.iter possible_solutions ~f:(fun solution ->
        let cue = Permutation.analyse ~solution ~candidate in
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
              ; next_best_guesses = Not_computed
              })
          else None)
    in
    Array.sort by_cue ~compare:(fun t1 t2 ->
        Int.compare t2.size_remaining t1.size_remaining);
    Nonempty_list.of_list_exn (Array.to_list by_cue)
  in
  let min_bits_gained =
    Nonempty_list.fold by_cue ~init:Float.infinity ~f:(fun acc t ->
        Float.min acc t.bits_gained)
  in
  let max_bits_gained =
    Nonempty_list.fold by_cue ~init:0. ~f:(fun acc t -> Float.max acc t.bits_gained)
  in
  let expected_bits_gained =
    Nonempty_list.fold by_cue ~init:0. ~f:(fun acc t ->
        acc +. (t.probability *. t.bits_gained))
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

let compute_k_best ?display ~possible_solutions ~k () =
  if k < 1 then raise_s [%sexp "k >= 1 value expected", [%here], { k : int }];
  let ts =
    Kheap.create ~k ~compare:(fun (t1 : t) t2 ->
        Float.compare t2.expected_bits_gained t1.expected_bits_gained)
  in
  let bar =
    let total = Permutation.cardinality in
    let open Progress.Line in
    list [ bar total; count_to total; parens (const "eta: " ++ eta total) ]
  in
  let with_reporter f =
    for candidate = 0 to Permutation.cardinality - 1 do
      f 1;
      let t =
        compute ~possible_solutions ~candidate:(Permutation.of_index_exn candidate)
      in
      if Float.( > ) t.expected_bits_gained 0. then Kheap.add ts t
    done
  in
  (match display with
  | None ->
    Progress.with_reporter
      ~config:(Progress.Config.v ~persistent:false ())
      bar
      with_reporter
  | Some display ->
    let reporter = Progress.Display.add_line display bar in
    with_reporter (fun v -> Progress.Reporter.report reporter v);
    Progress.Reporter.finalise reporter);
  Kheap.to_list ts
;;
