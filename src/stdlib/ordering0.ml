(*********************************************************************************)
(*  super-master-mind: A solver for the super master mind game                   *)
(*  SPDX-FileCopyrightText: 2021-2025 Mathieu Barbin <mathieu.barbin@gmail.com>  *)
(*  SPDX-License-Identifier: MIT                                                 *)
(*********************************************************************************)

include Ordering

let to_dyn = function
  | Lt -> Dyn0.variant "Lt" []
  | Eq -> Dyn0.variant "Eq" []
  | Gt -> Dyn0.variant "Gt" []
;;
