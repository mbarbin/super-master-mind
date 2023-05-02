open! Core

(** In the game, pins may be of 8 different colors. Colors may be encoded to
    allow for a more efficient representation. *)

type t [@@deriving compare, equal, hash, sexp]

val all : t list Lazy.t

module Hum : sig
  (** Human readable representation of colors. *)
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
end

val of_hum : Hum.t -> t
val to_hum : t -> Hum.t

(** The number of different colors that are encountered in the game. In this
    version of the game, this is [8] (see Hum.t). *)
val cardinality : int Lazy.t

(** Colors are ordered and indexed. The index may serve as efficient encoding. *)

(** [to_index t] returns the [index] of [t] in the total color set. It is
    guaranteed that [0 <= index < cardinality]. *)
val to_index : t -> int

(** [of_index index] returns the color at the given index. Indices are expected
    to verify [0 <= index < cardinality]. An invalid index will cause the
    function to raise. *)
val of_index_exn : int -> t
