open! Core

(** A permutation is a sequence of colors. A given solution to a game
   is a permutation, and each candidate submitted is a permutation as
   well. *)

(** [t] is a memory efficient representation for a permutation. *)
type t [@@deriving compare, equal, hash, sexp_of]

module Hum : sig
  (** Humam readable representation for a permutation. *)
  type t = Color.Hum.t array [@@deriving sexp_of]
end

(** Returns the efficient encoding of a given permutation. Raises if
   the size of the permutation does not match [size]. *)
val create_exn : Hum.t -> t

(** Returns the human readable representation of the permutation. *)
val to_hum : t -> Hum.t

(** The number of slots in the permutation. In this version of the
   game, this is [5]. *)
val size : int

(** The number of different permutations that can be formed using all
   available colors, allowing repetition of colors. *)
val cardinality : int

(** Permutations are ordered and indexed. The index may serve as efficient encoding. *)

(** [to_index t] returns the [index] of [t] in the total permutation set. It
   is guaranteed that [0 <= index < cardinality]. to be >= 0 *)
val to_index : t -> int

(** [of_index index] returns the permutation at the given index. Indices are
   expected to verify [0 <= index < cardinality]. An invalid index
   will cause the function to raise. *)
val of_index_exn : int -> t

module Cache : sig
  (** In order to avoid repeating operations, a cache is used. *)
  type t

  (** Allocates a new empty cache. *)
  val create : unit -> t
end

(** Analyse a pair (solution, candidate) and returns the correponding
   cue for it. The cache retains all calls to [analyse] with no
   eviction policy. *)
val analyse : cache:Cache.t -> solution:t -> candidate:t -> Cue.t

(** Private module exposing internal logic, used by tests. *)
module Private : sig
  val log2 : float -> float

  module Computing : sig
    (** A representation of a permutation well suited for matching
       computation. *)
    type t [@@deriving sexp_of]

    (** Returns the human readable representation of the permutation. *)
    val to_hum : t -> Hum.t

    (** Returns the encoding of a given permutation. Raises if the
       size of the permutation does not match [size]. *)
    val create_exn : Hum.t -> t

    (** Analyse the given pair and returns the given cue for it. *)
    val analyse : solution:t -> candidate:t -> Cue.t
  end
end
