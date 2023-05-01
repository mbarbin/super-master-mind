open! Core

(** The role of this module is to use some pre-computation for the beginning of
    the game in order for it to be fast. *)

type t [@@deriving sexp_of]

(** This is the main opening book used by the application. It is computed via
    [compute] and embedded as an s-expression. *)
val opening_book : t Lazy.t

(** Function used to recompute the opening book. *)
val compute : task_pool:Task_pool.t -> depth:int -> t

(** Return the depth that was used to compute [t]. *)
val depth : t -> int

(** Access the root of the book as a [Guess.t]. *)
val root : t -> color_permutation:Color_permutation.t -> Guess.t

(** The command exported as [super-master-mind opening-book]. *)
val cmd : Command.t
