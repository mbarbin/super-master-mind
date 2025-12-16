(*_********************************************************************************)
(*_  super-master-mind: A solver for the super master mind game                   *)
(*_  SPDX-FileCopyrightText: 2021-2025 Mathieu Barbin <mathieu.barbin@gmail.com>  *)
(*_  SPDX-License-Identifier: MIT                                                 *)
(*_********************************************************************************)

(** The role of this module is to use some pre-computation for the beginning of
    the game in order for it to be fast. *)

type t

(** This is the main opening book used by the application. It is computed via
    [compute] during development and installed with the package with [dune-site].

    Forcing this lazy causes the file to be loaded and parsed at runtime. *)
val opening_book : t Lazy.t

(** Function used to recompute the opening book. *)
val compute : task_pool:Task_pool.t -> depth:int -> t

(** Return the depth that was used to compute [t]. *)
val depth : t -> int

(** Access the root of the book as a [Guess.t]. *)
val root : t -> color_permutation:Color_permutation.t -> Guess.t

(** The command exported as [super-master-mind opening-book]. *)
val cmd : unit Command.t
