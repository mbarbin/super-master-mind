(*_********************************************************************************)
(*_  super-master-mind: A solver for the super master mind game                   *)
(*_  SPDX-FileCopyrightText: 2021-2025 Mathieu Barbin <mathieu.barbin@gmail.com>  *)
(*_  SPDX-License-Identifier: MIT                                                 *)
(*_********************************************************************************)

(** Extending [Stdlib] for use in the project. *)

module Code_error = Code_error
module Dyn = Dyn0
module Json = Json
module Ordering = Ordering
module Source_code_position = Source_code_position

val print_dyn : Dyn.t -> unit
val require : bool -> unit
val require_does_raise : (unit -> 'a) -> unit

module Array : sig
  include module type of struct
    include Stdlib.ArrayLabels
  end

  val is_empty : _ t -> bool
  val create : len:int -> 'a -> 'a t
  val filter_mapi : 'a t -> f:(int -> 'a -> 'b option) -> 'b t
  val fold : 'a t -> init:'acc -> f:('acc -> 'a -> 'acc) -> 'acc
  val foldi : 'a t -> init:'acc -> f:(int -> 'acc -> 'a -> 'acc) -> 'acc
  val sort : 'a t -> compare:('a -> 'a -> int) -> unit
end

module Hashtbl : sig
  include module type of struct
    include MoreLabels.Hashtbl
  end

  val set : ('key, 'data) t -> key:'key -> data:'data -> unit
end

module In_channel : sig
  include module type of struct
    include Stdlib.In_channel
  end

  val read_all : string -> string
end

module List : sig
  include module type of struct
    include Stdlib.ListLabels
  end

  val drop_while : 'a t -> f:('a -> bool) -> 'a t
  val iter : 'a t -> f:('a -> unit) -> unit
  val fold : 'a t -> init:'acc -> f:('acc -> 'a -> 'acc) -> 'acc
end

module Option : sig
  include module type of struct
    include Stdlib.Option
  end

  val bind : 'a t -> f:('a -> 'b option) -> 'b t
  val iter : 'a t -> f:('a -> unit) -> unit
  val some_if : bool -> 'a -> 'a t
end

module Out_channel : sig
  include module type of struct
    include Stdlib.Out_channel
  end

  val output_lines : t -> string list -> unit
  val with_open_text : string -> f:(t -> 'a) -> 'a
end

module Result : sig
  include module type of struct
    include Stdlib.Result
  end

  val bind : ('a, 'err) t -> f:('a -> ('b, 'err) t) -> ('b, 'err) t
  val map_error : ('a, 'err) t -> f:('err -> 'b) -> ('a, 'b) t
end
