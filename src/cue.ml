open! Core
open! Import

module Hum = struct
  type t =
    { white : int
    ; black : int
    }
  [@@deriving sexp]
end

let code_size = 5

(* The sum of [white] and [black] cannot exceed the code size. This
   means that given a correct value for [white], [black] has to verify
   : [0 <= black <= code_size - white].

   0 white: code_size + 1 choices for black 1 white: code_size - 1
   choices for black 2 white: code_size - 1 choices for black ... ps
   white: 1 choice for black (0). *)

let cardinality = ((code_size + 1) * (code_size + 2) / 2) - 1

module Raw_code = struct
  type t = int

  let of_hum { Hum.white; black } : t = (black * (code_size + 1)) + white
  let cardinality = (code_size + 1) * (code_size + 1)
end

let raw_code_to_index, index_to_hum =
  let index = ref (-1) in
  let raw_code_to_index = Array.create ~len:Raw_code.cardinality None in
  let index_to_hum = Array.create ~len:cardinality None in
  for white = 0 to code_size do
    for black = 0 to if white = 1 then code_size - 2 else code_size - white do
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

let t_of_sexp sexp = sexp |> [%of_sexp: Hum.t] |> create_exn
let all = List.init cardinality ~f:Fn.id
