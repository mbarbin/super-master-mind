(*_********************************************************************************)
(*_  super-master-mind: A solver for the super master mind game                   *)
(*_  SPDX-FileCopyrightText: 2021-2025 Mathieu Barbin <mathieu.barbin@gmail.com>  *)
(*_  SPDX-License-Identifier: MIT                                                 *)
(*_********************************************************************************)

(** Extending [Stdlib] for use in the project. *)

module Array = Array0
module Code_error = Code_error
module Dyn = Dyn0
module Float = Float0
module Fun = Fun0
module Hashtbl = Hashtbl0
module In_channel = In_channel0
module Int = Int0
module Json = Json
module List = List0
module Option = Option0
module Ordering = Ordering
module Out_channel = Out_channel0
module Result = Result0
module Source_code_position = Source_code_position
module String = String0

val phys_equal : 'a -> 'a -> bool
val print_dyn : Dyn.t -> unit
val require : bool -> unit
val require_does_raise : (unit -> 'a) -> unit

(** {1 Floating operations}

    The presence of these aliases has an impact on the precision of operations
    on macos-latest. Pragmatically we've observed that not having them creates
    small computational divergences in our tests between macos and ubuntu
    runners in the CI. *)

val ( +. ) : float -> float -> float
val ( -. ) : float -> float -> float
val ( *. ) : float -> float -> float
val ( /. ) : float -> float -> float
