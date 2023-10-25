open! Base

(** [t] is a container for several unordered [Code.t]. It is used to represent
    the set of possible solutions as the game goes on, shrinking from its
    original value (all possible combinations) down to the final guessed
    solution. *)

type t [@@deriving sexp_of]

(** A [t] representing the set of all possible codes. Its size is equal to ~32K
    elements. *)
val all : t

(** Returns the number of codes contained in [t]. *)
val size : t -> int

(** Returns the size of [t] expressed in a number of information bits. *)
val bits : t -> Float.t

(** [is_empty t = true] is equivalent to [size t = 0] but more efficient. *)
val is_empty : t -> bool

(** Return a new set of codes in which only those code which evaluates to the
    given cue with the given candidate are kept. Note this may return an empty
    set if the original [t] contains no such code. *)
val filter : t -> candidate:Code.t -> cue:Cue.t -> t

(** Access the elements of [t] in the form of a list. The order of codes is
    unspecified. *)
val to_list : t -> Code.t list

(** Iter through the code contained in [t]. *)
val iter : t -> f:(Code.t -> unit) -> unit
