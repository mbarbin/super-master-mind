(*_********************************************************************************)
(*_  super-master-mind: A solver for the super master mind game                   *)
(*_  SPDX-FileCopyrightText: 2021-2025 Mathieu Barbin <mathieu.barbin@gmail.com>  *)
(*_  SPDX-License-Identifier: MIT                                                 *)
(*_********************************************************************************)

(** Extending [Stdlib] for use in the project. *)

module Code_error = Code_error
module Dyn = Dyn
module Ordering = Ordering
module Source_code_position = Source_code_position

val print_dyn : Dyn.t -> unit
val require : bool -> unit
val require_does_raise : (unit -> 'a) -> unit
