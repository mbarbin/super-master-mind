open! Core

(** The role of this module is to use some pre-computation for the
   beginning of the game in order for it to be fast. *)

type t [@@deriving sexp_of]

(** This is the main opening book used by the application. It is
   computed via [compute] and embedded as an s-expression. *)
val opening_book : t Lazy.t

(** A canonical first candidate: simply the 5 first different colors. *)
val canonical_first_candidate : Permutation.t

(** Function used to recompute the opening book. *)
val compute : unit -> t

(** The command exported as [super-master-mind opening-book]. *)
val cmd : Command.t
