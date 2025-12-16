(*_********************************************************************************)
(*_  super-master-mind: A solver for the super master mind game                   *)
(*_  SPDX-FileCopyrightText: 2021-2025 Mathieu Barbin <mathieu.barbin@gmail.com>  *)
(*_  SPDX-License-Identifier: MIT                                                 *)
(*_********************************************************************************)

(** Extending [Lexing.position] for use in the project. *)

type t = Lexing.position =
  { pos_fname : string
  ; pos_lnum : int
  ; pos_bol : int
  ; pos_cnum : int
  }

val to_dyn : t -> Dyn.t

(** To be used with the [__POS__] special construct. For example:

    {[
      of_pos __POS__
    ]}

    As a limitation, [pos_bol] is set to zero by this constructor. *)
val of_pos : string * int * int * _ -> t
