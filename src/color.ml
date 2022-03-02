open! Core

let cardinality = 8

module Hum = struct
  type t =
    | Black
    | Blue
    | Brown
    | Green
    | Orange
    | Red
    | White
    | Yellow
  [@@deriving enumerate, sexp_of]

  let to_index = function
    | Black -> 0
    | Blue -> 1
    | Brown -> 2
    | Green -> 3
    | Orange -> 4
    | Red -> 5
    | White -> 6
    | Yellow -> 7
  ;;

  let of_index_exn = function
    | 0 -> Black
    | 1 -> Blue
    | 2 -> Brown
    | 3 -> Green
    | 4 -> Orange
    | 5 -> Red
    | 6 -> White
    | 7 -> Yellow
    | code -> raise_s [%sexp "Invalid code", [%here], { code : int }]
  ;;

  let () = assert (List.length all = cardinality)
end

type t = int [@@deriving compare, equal, hash]

let to_hum = Hum.of_index_exn
let of_hum = Hum.to_index
let to_index t = t

let of_index_exn index =
  if not (0 <= index && index < cardinality)
  then raise_s [%sexp "Index out of bounds", [%here], (index : int)];
  index
;;

let all = List.map Hum.all ~f:of_hum
let sexp_of_t t = [%sexp (to_hum t : Hum.t)]
