(*_********************************************************************************)
(*_  super-master-mind: A solver for the super master mind game                   *)
(*_  SPDX-FileCopyrightText: 2021-2025 Mathieu Barbin <mathieu.barbin@gmail.com>  *)
(*_  SPDX-License-Identifier: MIT                                                 *)
(*_********************************************************************************)

include module type of struct
  include Stdlib.ArrayLabels
end

val equal : ('a -> 'a -> bool) -> 'a t -> 'a t -> bool
val is_empty : _ t -> bool
val create : len:int -> 'a -> 'a t
val filter_mapi : 'a t -> f:(int -> 'a -> 'b option) -> 'b t
val fold : 'a t -> init:'acc -> f:('acc -> 'a -> 'acc) -> 'acc
val foldi : 'a t -> init:'acc -> f:(int -> 'acc -> 'a -> 'acc) -> 'acc
val sort : 'a t -> compare:('a -> 'a -> Ordering.t) -> unit
