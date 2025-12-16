(*_********************************************************************************)
(*_  super-master-mind: A solver for the super master mind game                   *)
(*_  SPDX-FileCopyrightText: 2021-2025 Mathieu Barbin <mathieu.barbin@gmail.com>  *)
(*_  SPDX-License-Identifier: MIT                                                 *)
(*_********************************************************************************)

(*_ Inspired by a similar module in stdune. *)

(** A programming error that should be reported upstream *)

type t =
  { message : string
  ; data : (string * Dyn.t) list
  }

exception E of t

val raise : string -> (string * Dyn.t) list -> _
