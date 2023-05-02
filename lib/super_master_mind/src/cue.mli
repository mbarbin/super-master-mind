open! Base

(** During a game, when a player submits a guess (also called a candidate code),
    the other player responds by given back a cue. The cue gives an indication
    as to how close the guess is to the actual solution, by telling how many
    colors are correct and how many are misplaced.

    A misplaced color gets a white pin, while a correct color at the right place
    gets a black pin. *)

(** [t] is an efficient representation for a cue. *)
type t [@@deriving compare, equal, hash, sexp]

val all : t list Lazy.t

module Hum : sig
  (** Human readable representation for a cue. *)
  type t =
    { white : int
    ; black : int
    }
  [@@deriving sexp]
end

(** The number of different cues that are encountered in the game. *)
val cardinality : int Lazy.t

(** Cues are ordered and indexed. The index may serve as efficient encoding. *)

(** [to_index t] returns the [index] of [t] in the total cue set. It is
    guaranteed that [0 <= index < cardinality]. *)
val to_index : t -> int

(** [of_index index] returns the cue at the given index. Indices are expected to
    verify [0 <= index < cardinality]. An invalid index will cause the function
    to raise. *)
val of_index_exn : int -> t

(** Returns the efficient encoding of a given cue. Raises if the values for
    [white] and [black] are invalid. *)
val create_exn : Hum.t -> t

(** Returns the human readable representation of the cue. *)
val to_hum : t -> Hum.t

(** That is the number of slots in the solution, as well as all candidates
    submitted as guesses. In this version of the game, this is [5]. *)
val code_size : int Lazy.t
