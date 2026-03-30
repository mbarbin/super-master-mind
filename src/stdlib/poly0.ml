(*********************************************************************************)
(*  super-master-mind: A solver for the super master mind game                   *)
(*  SPDX-FileCopyrightText: 2021-2025 Mathieu Barbin <mathieu.barbin@gmail.com>  *)
(*  SPDX-License-Identifier: MIT                                                 *)
(*********************************************************************************)

let compare a b = Stdlib.compare a b |> Ordering.of_int
let equal = Stdlib.( = )
let hash = Stdlib.Hashtbl.hash
