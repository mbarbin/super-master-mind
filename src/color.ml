(*********************************************************************************)
(*  super-master-mind: A solver for the super master mind game                   *)
(*  SPDX-FileCopyrightText: 2021-2025 Mathieu Barbin <mathieu.barbin@gmail.com>  *)
(*  SPDX-License-Identifier: MIT                                                 *)
(*********************************************************************************)

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
  [@@deriving compare, equal, sexp]

  let all = [ Black; Blue; Brown; Green; Orange; Red; White; Yellow ]

  let to_dyn = function
    | Black -> Dyn.variant "Black" []
    | Blue -> Dyn.variant "Blue" []
    | Brown -> Dyn.variant "Brown" []
    | Green -> Dyn.variant "Green" []
    | Orange -> Dyn.variant "Orange" []
    | Red -> Dyn.variant "Red" []
    | White -> Dyn.variant "White" []
    | Yellow -> Dyn.variant "Yellow" []
  ;;

  let t_of_sexp sexp =
    match t_of_sexp sexp with
    | t -> t
    | exception _ ->
      Code_error.raise "Invalid color." [ "sexp", Dyn.string (Sexp.to_string sexp) ]
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
    | code -> Code_error.raise "Invalid code." [ "code", Dyn.int code ]
  ;;
end

type t = int [@@deriving compare, equal]

let to_hum = Hum.of_index_exn
let of_hum = Hum.to_index
let to_index t = t
let to_dyn t = t |> to_hum |> Hum.to_dyn

let of_index_exn index =
  let cardinality = force cardinality in
  if not (0 <= index && index < cardinality)
  then
    Code_error.raise
      "Index out of bounds."
      [ "index", Dyn.int index; "cardinality", Dyn.int cardinality ];
  index
;;

let all = lazy (List.init ~len:(Lazy.force cardinality) ~f:Fn.id)
let sexp_of_t t = to_hum t |> Hum.sexp_of_t

let t_of_sexp sexp =
  match sexp |> [%of_sexp: Hum.t] with
  | hum -> hum |> of_hum
  | exception _ ->
    Code_error.raise "Invalid color." [ "sexp", Dyn.string (Sexp.to_string sexp) ]
;;
