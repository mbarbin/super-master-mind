open! Core

(** A each point of the game, there's a number of remaining possible
   solutions. Each guess that one can make may be evaluated in order
   to determine its quality. The goal of the guessing player is to
   propose candidates that maximize the expected value of the amount
   of information they'll get in return. *)

module rec By_cue : sig
  type t =
    { cue : Cue.t
    ; size_remaining : int
    ; bits_remaining : float
    ; bits_gained : float
    ; probability : float
    }
  [@@deriving equal, sexp_of]
end

and T : sig
  type t =
    { candidate : Permutation.t
    ; expected_bits_gained : float
    ; expected_bits_remaining : float
    ; min_bits_gained : float
    ; max_bits_gained : float
    ; max_bits_remaining : float
    ; by_cue : By_cue.t array (** Sorted by decreasing number of remaining sizes *)
    }
  [@@deriving equal, sexp_of]
end

include module type of struct
  include T
end

val compute
  :  cache:Permutation.Cache.t
  -> possible_solutions:Permutations.t
  -> candidate:Permutation.t
  -> t

val compute_k_best
  :  cache:Permutation.Cache.t
  -> possible_solutions:Permutations.t
  -> k:int
  -> t list
