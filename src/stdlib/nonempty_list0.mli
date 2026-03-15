(*_********************************************************************************)
(*_  super-master-mind: A solver for the super master mind game                   *)
(*_  SPDX-FileCopyrightText: 2021-2025 Mathieu Barbin <mathieu.barbin@gmail.com>  *)
(*_  SPDX-License-Identifier: MIT                                                 *)
(*_********************************************************************************)

(** A list that is statically guaranteed to be non-empty. *)

type 'a t = ( :: ) of 'a * 'a list

val singleton : 'a -> 'a t
val hd : 'a t -> 'a
val tl : 'a t -> 'a list
val cons : 'a -> 'a t -> 'a t
val of_list_exn : 'a list -> 'a t
val to_list : 'a t -> 'a list
val to_array : 'a t -> 'a array
val length : 'a t -> int
val init : int -> f:(int -> 'a) -> 'a t
val append : 'a t -> 'a list -> 'a t
val map : 'a t -> f:('a -> 'b) -> 'b t
val mapi : 'a t -> f:(int -> 'a -> 'b) -> 'b t
val iter : 'a t -> f:('a -> unit) -> unit
val fold : 'a t -> init:'acc -> f:('acc -> 'a -> 'acc) -> 'acc
val find : 'a t -> f:('a -> bool) -> 'a option
val filter : 'a t -> f:('a -> bool) -> 'a list
val filter_map : 'a t -> f:('a -> 'b option) -> 'b list
val concat_map : 'a t -> f:('a -> 'b t) -> 'b t
val max_elt : 'a t -> compare:('a -> 'a -> Ordering.t) -> 'a

module type Summable = sig
  type t

  val zero : t
  val ( + ) : t -> t -> t
end

val sum : (module Summable with type t = 'sum) -> 'a t -> f:('a -> 'sum) -> 'sum

(** {1 Derivation support} *)

val compare : ('a -> 'a -> Ordering.t) -> 'a t -> 'a t -> Ordering.t
val equal : ('a -> 'a -> bool) -> 'a t -> 'a t -> bool

module Or_unequal_lengths : sig
  type 'a t =
    | Ok of 'a
    | Unequal_lengths
end

val zip : 'a t -> 'b t -> ('a * 'b) t Or_unequal_lengths.t
