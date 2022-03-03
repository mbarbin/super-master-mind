open! Core

(** Print and return the steps that lead to finding the solution given
   as paramter. *)
val solve : solution:Permutation.t -> Guess.t list

(** A command that runs [solve]. *)
val cmd : Command.t
