open! Core
open! Import

(** So that the code is easier to test with smaller versions of the game, we
    make the rest of the code depend on global dimensions that are made
    available in this module. To change the default dimensions, the values
    must be set before evaluating any Lazy.t value that depends on it (which
    makes the use of this module brittle). If things get broken this will be
    easily spotted by the tests. *)

val use_small_game_dimensions_exn : Source_code_position.t -> unit
val param : Source_code_position.t -> unit Command.Param.t

(** {1 Root dimensions} *)

val code_size : Source_code_position.t -> int
val num_colors : Source_code_position.t -> int
