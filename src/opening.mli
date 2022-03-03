open! Core

(** The role of this module is to use some pre-computation for the
   beginning of the game in order for it to be fast. *)

type t [@@deriving sexp_of]

val compute : unit -> t
val cmd : Command.t
