open! Core

(** The role of this module is to use some pre-computation for the
   beginning of the game in order for it to be fast. *)

type t [@@deriving sexp_of]

(** A canonical first candidate: simply the 5 first different colors. *)
val canonical_first_candidate : Permutation.t

val compute : unit -> t
val cmd : Command.t
