open! Core

module Hum = struct
  type t =
    { white : int
    ; black : int
    }
  [@@deriving sexp_of]
end

let permutation_size = 5

(* The sum of [white] and [black] cannot exceed the permutation size.
   This means that given a correct value for [white], [black] has to
   verify : [0 <= black <= permutation_size - white].

   0 white: permutation_size + 1 choices for black
   1 white: permutation_size     choices for black
   2 white: permutation_size - 1 choices for black
   ...
   ps white: 1 choice for black (0).

   cardinality: (permutation_size + 1) * (permutation_size + 2) / 2
*)

let cardinality = (permutation_size + 1) * (permutation_size + 2) / 2

module Raw_code = struct
  type t = int

  let of_hum { Hum.white; black } = (black * (permutation_size + 1)) + white
  let cardinality = (permutation_size + 1) * (permutation_size + 1)
end

let zero = { Hum.white = 0; black = 0 }

let raw_code_to_index, index_to_hum =
  let index = ref (-1) in
  let raw_code_to_index = Array.create Raw_code.cardinality None in
  let index_to_hum = Array.create cardinality None in
  for white = 0 to permutation_size do
    for black = 0 to permutation_size - white do
      let hum = { Hum.white; black } in
      let raw_code = Raw_code.of_hum hum in
      let index =
        Int.incr index;
        !index
      in
      raw_code_to_index.(raw_code) <- Some index;
      index_to_hum.(index) <- Some hum
    done
  done;
  let index_to_hum =
    Array.mapi index_to_hum ~f:(fun i value ->
        match value with
        | Some value -> value
        | None -> raise_s [%sexp "Missing index", [%here], (i : int)])
  in
  raw_code_to_index, index_to_hum
;;

(* [t] represents the index of the cue. *)
type t = int [@@deriving compare, equal, hash]

let to_index t = t
let to_hum t = index_to_hum.(t)
let sexp_of_t t = [%sexp (to_hum t : Hum.t)]

let of_index_exn index =
  if not (0 <= index && index < cardinality)
  then raise_s [%sexp "Index out of bounds", [%here], (index : int)];
  index
;;

let create_exn hum =
  let raw_code = Raw_code.of_hum hum in
  match raw_code_to_index.(raw_code) with
  | Some index -> index
  | None -> raise_s [%sexp "Invalid hum representation", [%here], (hum : Hum.t)]
;;

let all = List.init cardinality ~f:Fn.id
