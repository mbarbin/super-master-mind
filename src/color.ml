(*********************************************************************************)
(*  super-master-mind: A solver for the super master mind game                   *)
(*  SPDX-FileCopyrightText: 2021-2025 Mathieu Barbin <mathieu.barbin@gmail.com>  *)
(*  SPDX-License-Identifier: MIT                                                 *)
(*********************************************************************************)

let cardinality =
  lazy (Game_dimensions.num_colors (Source_code_position.of_pos Stdlib.__POS__))
;;

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

  let equal : t -> t -> bool = Stdlib.( = )
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

  let to_string = function
    | Black -> "Black"
    | Blue -> "Blue"
    | Brown -> "Brown"
    | Green -> "Green"
    | Orange -> "Orange"
    | Red -> "Red"
    | White -> "White"
    | Yellow -> "Yellow"
  ;;

  let of_string_opt = function
    | "Black" -> Some Black
    | "Blue" -> Some Blue
    | "Brown" -> Some Brown
    | "Green" -> Some Green
    | "Orange" -> Some Orange
    | "Red" -> Some Red
    | "White" -> Some White
    | "Yellow" -> Some Yellow
    | _ -> None
  ;;

  let of_string_exn s =
    match of_string_opt s with
    | Some t -> t
    | None -> Code_error.raise "Invalid color." [ "color", Dyn.string s ]
  ;;

  let to_json t : Json.t = `String (to_string t)

  let of_json (json : Json.t) : t =
    match json with
    | `String s ->
      (match of_string_opt s with
       | Some t -> t
       | None -> raise (Json.Invalid_json ("Invalid color for [Color.Hum.t].", json)))
    | _ -> raise (Json.Invalid_json ("Expected string for [Color.Hum.t].", json))
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

type t = int

let equal = Int.equal
let compare = Int.compare
let to_hum = Hum.of_index_exn
let of_hum = Hum.to_index
let to_index t = t
let to_dyn t = t |> to_hum |> Hum.to_dyn

let of_index_exn index =
  let cardinality = Lazy.force cardinality in
  if not (0 <= index && index < cardinality)
  then
    Code_error.raise
      "Index out of bounds."
      [ "index", Dyn.int index; "cardinality", Dyn.int cardinality ];
  index
;;

let all = lazy (List.init ~len:(Lazy.force cardinality) ~f:Fun.id)
let to_json t : Json.t = to_hum t |> Hum.to_json
let of_json (json : Json.t) : t = json |> Hum.of_json |> of_hum
