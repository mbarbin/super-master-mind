open! Core

(** Print and return the steps that lead to finding the solution given as
    parameter. *)
val solve : color_permutation:Color_permutation.t -> solution:Code.t -> Guess.t list

(** A command that runs [solve]. *)
val cmd : Command.t
