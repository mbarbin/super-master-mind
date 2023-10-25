open! Base

(** In order for the program to vary its opening guesses, we can choose to map
    the opening book through a color permutation, that is a bijection from the
    set of colors onto itself. *)

type t [@@deriving compare, equal, hash, sexp]

(** The permutation that maps each color to itself. *)
val identity : t Lazy.t

(** The main operation for which a color permutation is used. A permutation is a
    bijection of the set of colors onto itself. *)
val map_color : t -> Color.t -> Color.t

(** Build the reciprocal of [t]. *)
val inverse : t -> t

(** Returns the human readable representation of the color permutation. *)
val to_hum : t -> Color.Hum.t array

(** Returns the color permutation represented by the input array. Raises if the
    size of the array is not [Color.cardinality] or if it contains repeated
    colors. *)
val create_exn : Color.Hum.t array -> t

(** The number of different color permutations that exists. *)
val cardinality : int Lazy.t

(** Color permutations are ordered and indexed. The index may serve as efficient
    encoding. *)

(** [to_index t] returns the [index] of [t] in the color permutation set. It is
    guaranteed that [0 <= index < cardinality]. *)
val to_index : t -> int

(** [of_index index] returns the color permutation at the given index. Indices
    are expected to verify [0 <= index < cardinality]. An invalid index will
    cause the function to raise. *)
val of_index_exn : int -> t
