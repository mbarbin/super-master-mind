open! Core

(** A [Kheap.t] is a mutable containers that retains the [k] smallest
   elements added to it overtime (and discard the others). *)

type 'a t [@@deriving sexp_of]

(** [create ~k ~compare] creates a new kheap of size [k], which will
   use the provided comparison function to identify the smallest
   elements. Once created, the size of the heap (k) and the comparison
   function (compare) may not be changed. *)
val create : k:int -> compare:('a -> 'a -> int) -> 'a t

(** [add t a] will take a slot in [t] if [a] is smallest that the
   values already present in the kheap. If the resulting number of
   elements exceeds [k], the bigger elements will be discarded. If [a]
   is bigger than the [k] elements already present in [t], [add t a]
   will have no effect on [t]. *)
val add : 'a t -> 'a -> unit

(** Returns the elements of [t] ordered increasingly. *)
val to_list : 'a t -> 'a list
