(*_********************************************************************************)
(*_  super-master-mind: A solver for the super master mind game                   *)
(*_  SPDX-FileCopyrightText: 2021-2025 Mathieu Barbin <mathieu.barbin@gmail.com>  *)
(*_  SPDX-License-Identifier: MIT                                                 *)
(*_********************************************************************************)

(** A code is a sequence of colors, allowing repetition. A given solution to a
    game is a code, and each candidate submitted during the game is a code as
    well. *)

(** [t] is a memory efficient representation for a code. *)
type t [@@deriving compare, equal, hash, sexp]

module Hum : sig
  (** Human readable representation for a code. *)
  type t = Color.Hum.t array [@@deriving sexp]
end

(** Returns the efficient encoding of a given code. Raises if the size of the
    code does not match [size]. *)
val create_exn : Hum.t -> t

(** Returns the human readable representation of the code. *)
val to_hum : t -> Hum.t

(** The number of slots in the code. In this version of the game, this is [5]. *)
val size : int Lazy.t

(** The number of different codes that can be formed using all available colors,
    allowing repetition of colors. *)
val cardinality : int Lazy.t

(** Codes are ordered and indexed. The index may serve as efficient encoding. *)

(** [to_index t] returns the [index] of [t] in the total code set. It is
    guaranteed that [0 <= index < cardinality]. *)
val to_index : t -> int

(** [of_index index] returns the code at the given index. Indices are expected
    to verify [0 <= index < cardinality]. An invalid index will cause the
    function to raise. *)
val of_index_exn : int -> t

(** Analyze a pair (solution, candidate) and returns the corresponding cue for
    it. *)
val analyze : solution:t -> candidate:t -> Cue.t

(** Map the colors of a code according to a given color permutation. *)
val map_color : t -> color_permutation:Color_permutation.t -> t

(** Parse a code from the command line. *)
val param : t Command.Param.t
