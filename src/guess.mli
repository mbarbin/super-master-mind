(*_********************************************************************************)
(*_  super-master-mind: A solver for the super master mind game                   *)
(*_  SPDX-FileCopyrightText: 2021-2025 Mathieu Barbin <mathieu.barbin@gmail.com>  *)
(*_  SPDX-License-Identifier: MIT                                                 *)
(*_********************************************************************************)

(** A each point of the game, there's a number of remaining possible solutions.
    Each guess that one can make may be evaluated in order to determine its
    quality. The goal of the guessing player is to propose candidates that
    maximize the expected value of the amount of information they'll get in
    return. *)

module rec Next_best_guesses : sig
  (** When computed, best guesses are sorted by decreasing number of
      expected_bits_gained. The functions in this module do not compute best
      guesses recursively, thus they will all produce guesses where
      [next_best_guesses = Not_computed]. For computed guesses, see the opening
      book. *)
  type t =
    | Not_computed
    | Computed of T.t list
  [@@deriving equal]

  val to_dyn : t -> Dyn.t
end

and By_cue : sig
  type t =
    { cue : Cue.t
    ; size_remaining : int
    ; bits_remaining : float
    ; bits_gained : float
    ; probability : float
    ; next_best_guesses : Next_best_guesses.t
    }
  [@@deriving equal]

  val to_dyn : t -> Dyn.t
end

and T : sig
  type t =
    { candidate : Code.t
    ; expected_bits_gained : float
    ; expected_bits_remaining : float
    ; min_bits_gained : float
    ; max_bits_gained : float
    ; max_bits_remaining : float
    ; by_cue : By_cue.t Nonempty_list.t
      (** Sorted by decreasing number of remaining sizes *)
    }
  [@@deriving equal]

  val to_dyn : t -> Dyn.t
end

include module type of struct
  include T
end

(** Compute the cues and expected probabilities for a candidate at a given stage
    of the game. *)
val compute : possible_solutions:Codes.t -> candidate:Code.t -> t

(** Go over all the possible candidates and retain the k that yield the best
    expected information.

    Because this computation tends to be long, [compute_k_best] reports its
    progression into a progress bar:

    1. If [display] is provided, a new bar will be added to it. This is used for
    example during the computation of the opening-book, when each level of
    the computation at different depths gets its own bar. In this case, the
    new bar is removed upon completion and before the function returns, and
    the display is left open.

    2. If [display] is not provided, this functions creates a new display with a
    single line in it. In this case the new display is closed before the
    function returns. *)
val compute_k_best
  :  ?display:_ Progress.Display.t
  -> task_pool:Task_pool.t
  -> possible_solutions:Codes.t
  -> k:int
  -> unit
  -> t list

module Verify_error : sig
  type t

  val print_hum : t -> Out_channel.t -> unit
  val to_dyn : t -> Dyn.t
end

(** Check the accuracy of all computed numbers contained in [t]. *)
val verify : t -> possible_solutions:Codes.t -> (unit, Verify_error.t) Result.t

(** Map the color of all codes contained by [t] according to a given color
    permutation. *)
val map_color : t -> color_permutation:Color_permutation.t -> t

val to_json : t -> Json.t
val of_json : Json.t -> t
