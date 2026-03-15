(*_********************************************************************************)
(*_  super-master-mind: A solver for the super master mind game                   *)
(*_  SPDX-FileCopyrightText: 2021-2025 Mathieu Barbin <mathieu.barbin@gmail.com>  *)
(*_  SPDX-License-Identifier: MIT                                                 *)
(*_********************************************************************************)

include module type of struct
  include Stdlib.ListLabels
end

val drop_while : 'a t -> f:('a -> bool) -> 'a t
val equal : ('a -> 'a -> bool) -> 'a t -> 'a t -> bool
val is_empty : _ t -> bool
val iter : 'a t -> f:('a -> unit) -> unit
val fold : 'a t -> init:'acc -> f:('acc -> 'a -> 'acc) -> 'acc
