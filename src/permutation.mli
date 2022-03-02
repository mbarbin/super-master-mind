open! Base

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

module Cache : sig
  (** In order to avoid repeating operations, a cache is used. *)
  type t

  (** Allocates a new empty cache. *)
  val create : unit -> t
end

(** Analyse the pair and returns the correponding cue for it. The
   cache retains all calls to [analyse] with no eviction policy. *)
val analyse : cache:Cache.t -> solution:t -> candidate:t -> Cue.t

module Solution_set : sig
  type permutation
  type t [@@deriving sexp_of]

  val all : t Lazy.t
  val size : t -> int
  val restrict : t -> cache:Cache.t -> candidate:permutation -> cue:Cue.t -> t
  val bits : t -> Float.t
  val to_list : t -> permutation list
end
with type permutation := t

module Outcome_by_cue : sig
  type t =
    { cue : Cue.t
    ; remains : Solution_set.t
    ; size : int
    }
  [@@deriving sexp_of]

  val bits : t -> Float.t
end

module Outcome : sig
  type permutation

  type t =
    { candidate : permutation
    ; by_cue : Outcome_by_cue.t array (* Sorted by increasing number of remaining sizes *)
    ; expected_score : float
    }
  [@@deriving sexp_of]
end
with type permutation := t

val step_candidate : cache:Cache.t -> solution_set:Solution_set.t -> Outcome.t list

(** Private module exposing internal logic, used by tests. *)
module Private : sig
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
