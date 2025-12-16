(*********************************************************************************)
(*  super-master-mind: A solver for the super master mind game                   *)
(*  SPDX-FileCopyrightText: 2021-2025 Mathieu Barbin <mathieu.barbin@gmail.com>  *)
(*  SPDX-License-Identifier: MIT                                                 *)
(*********************************************************************************)

module Hum = struct
  type t =
    { white : int
    ; black : int
    }
  [@@deriving sexp]

  let to_dyn { white; black } =
    Dyn.record [ "white", Dyn.int white; "black", Dyn.int black ]
  ;;
end

let code_size =
  lazy (Game_dimensions.code_size (Source_code_position.of_pos Stdlib.__POS__))
;;

(* The sum of [white] and [black] cannot exceed the code size. This means that
   given a correct value for [white], [black] has to verify:
   [0 <= black <= code_size - white].

   - white=0: code_size + 1 choices for black
   - white=1: code_size     choices for black
   - white=2: code_size - 1 choices for black
   - ...
   - white=cs: 1 choice for black (=> black=0). *)

let cardinality =
  lazy
    (let code_size = Lazy.force code_size in
     ((code_size + 1) * (code_size + 2) / 2) - 1)
;;

module Raw_code = struct
  type t = int

  let of_hum { Hum.white; black } : t = (black * (Lazy.force code_size + 1)) + white

  let cardinality =
    lazy
      (let code_size = Lazy.force code_size in
       (code_size + 1) * (code_size + 1))
  ;;
end

module Cache = struct
  type t =
    { raw_code_to_index : int option array
    ; index_to_hum : Hum.t array
    }

  let value =
    lazy
      (let index = ref (-1) in
       let code_size = Lazy.force code_size in
       let raw_code_to_index = Array.create ~len:(Lazy.force Raw_code.cardinality) None in
       let index_to_hum = Array.create ~len:(Lazy.force cardinality) None in
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
           | None -> Code_error.raise "Missing index." [ "i", Dyn.int i ])
       in
       { raw_code_to_index; index_to_hum })
  ;;
end

(* [t] represents the index of the cue. *)
type t = int [@@deriving compare, equal]

let to_index t = t

let to_hum t =
  let cache = Lazy.force Cache.value in
  cache.index_to_hum.(t)
;;

let sexp_of_t t = to_hum t |> Hum.sexp_of_t
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

let create_exn hum =
  let raw_code = Raw_code.of_hum hum in
  let cache = Lazy.force Cache.value in
  match cache.raw_code_to_index.(raw_code) with
  | Some index -> index
  | None -> Code_error.raise "Invalid cue." [ "hum", Hum.to_dyn hum ]
;;

let t_of_sexp sexp = sexp |> [%of_sexp: Hum.t] |> create_exn
let all = lazy (List.init ~len:(Lazy.force cardinality) ~f:Fn.id)
let to_json t : Json.t = `Int (to_index t)

let of_json (json : Json.t) : t =
  match json with
  | `Int i -> of_index_exn i
  | _ -> raise (Json.Invalid_json ("Expected int for [Cue.t].", json))
;;
