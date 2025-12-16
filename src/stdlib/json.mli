(*_********************************************************************************)
(*_  super-master-mind: A solver for the super master mind game                   *)
(*_  SPDX-FileCopyrightText: 2021-2025 Mathieu Barbin <mathieu.barbin@gmail.com>  *)
(*_  SPDX-License-Identifier: MIT                                                 *)
(*_********************************************************************************)

type t = Yojson.Basic.t

exception Invalid_json of string * t
exception Parse_error of string

val load : file:string -> t
val save : t -> file:string -> unit
val to_string : t -> string
val of_string : string -> t
