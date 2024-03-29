let cardinality = lazy (Game_dimensions.num_colors [%here])

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
  [@@deriving compare, equal, enumerate, hash, sexp]

  let t_of_sexp sexp =
    match t_of_sexp sexp with
    | t -> t
    | exception _ -> raise_s [%sexp "Invalid color", (sexp : Sexp.t)]
  ;;

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
end

type t = int [@@deriving compare, equal, hash]

let to_hum = Hum.of_index_exn
let of_hum = Hum.to_index
let to_index t = t

let of_index_exn index =
  let cardinality = force cardinality in
  if not (0 <= index && index < cardinality)
  then raise_s [%sexp "Index out of bounds", { index : int; cardinality : int }];
  index
;;

let all = lazy (List.init (force cardinality) ~f:Fn.id)
let sexp_of_t t = [%sexp (to_hum t : Hum.t)]

let t_of_sexp sexp =
  match sexp |> [%of_sexp: Hum.t] with
  | hum -> hum |> of_hum
  | exception _ -> raise_s [%sexp "Invalid color", (sexp : Sexp.t)]
;;
