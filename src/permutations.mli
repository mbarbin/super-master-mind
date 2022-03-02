open! Core

(** [t] is a container for several unordered [Permutation.t]. It is
   used to represent the set of possible solutions as the game goes
   on, shrinking from its original value (all possible combinations)
   down to the final guessed solution. *)

type t [@@deriving sexp_of]

(** A [t] containing all possible permutations. It is lazy as it takes
   some resource to compute (cardinality ~32K elements). *)
val all : t Lazy.t

(** Returns the number of permutations contained in [t]. *)
val size : t -> int

(** Returns the size of [t] expressed in a number of information bits. *)
val bits : t -> Float.t

(** Return a new set of permutations in which only those permutation
   which evaluates to the given cue with the given candidate are kept.
   Note this may return an empty set if the original [t] contains no
   such permutation. *)
val filter : t -> cache:Permutation.Cache.t -> candidate:Permutation.t -> cue:Cue.t -> t

(** Access the elements of [t] in the form of a list. The order of permutations is unspecified. *)
val to_list : t -> Permutation.t list

(** Iter through the permutation contained in [t]. *)
val iter : t -> f:(Permutation.t -> unit) -> unit
