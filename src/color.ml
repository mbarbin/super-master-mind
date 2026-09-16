(*********************************************************************************)
(*  super-master-mind: A solver for the super master mind game                   *)
(*  SPDX-FileCopyrightText: 2021-2025 Mathieu Barbin <mathieu.barbin@gmail.com>  *)
(*  SPDX-License-Identifier: MIT                                                 *)
(*********************************************************************************)

let cardinality = lazy (Game_dimensions.num_colors (Source_code_position.of_pos __POS__))

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

  let equal : t -> t -> bool = Poly.equal
  let all = [ Black; Blue; Brown; Green; Orange; Red; White; Yellow ]

  let to_variant_constructor_name = function
    | Black -> "Black"
    | Blue -> "Blue"
    | Brown -> "Brown"
    | Green -> "Green"
    | Orange -> "Orange"
    | Red -> "Red"
    | White -> "White"
    | Yellow -> "Yellow"
  ;;

  let to_dyn t = Dyn.variant (to_variant_constructor_name t) []
  let to_string = to_variant_constructor_name

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

  let of_string s =
    match of_string_opt s with
    | Some t -> Ok t
    | None -> Error (`Msg (Printf.sprintf "Invalid color %S." s))
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
    (* [t] values are only built by [of_index_exn] and [of_hum] below, which
       both guarantee an index within bounds, thus this branch is unreachable. *)
    | code -> Code_error.raise "Invalid code." [ "code", Dyn.int code ] [@coverage off]
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
      [ "index", Dyn.int index; "cardinality", Dyn.int cardinality ] [@coverage off];
  index
;;

let all = lazy (List.init ~len:(Lazy.force cardinality) ~f:Fun.id)
