open! Core

(** A each point of the game, there's a number of remaining possible
   solutions. Each guess that one can make may be evaluated in order
   to determine its quality. The goal of the guessing player is to
   propose candidates that maximize the expected value of the amount
   of information they'll get in return. *)

module rec Next_best_guesses : sig
  (** When computed, best guesses are sorted by decreasing number of
     expected_bits_gained. The functions in this module do not compute
     best guesses recursively, thus they will all produce guesses
     where [next_best_guesses = Not_computed]. For computed guesses,
     see the opening book. *)
  type t =
    | Not_computed
    | Computed of T.t list
  [@@deriving equal, sexp]
end

and By_cue : sig
  type t =
    { cue : Cue.t
    ; size_remaining : int
    ; bits_remaining : float
    ; bits_gained : float
    ; probability : float
    ; mutable next_best_guesses : Next_best_guesses.t
    }
  [@@deriving equal, sexp]
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
  [@@deriving equal, sexp]
end

include module type of struct
  include T
end

val compute : possible_solutions:Permutations.t -> candidate:Permutation.t -> t
val compute_k_best : possible_solutions:Permutations.t -> k:int -> t list
