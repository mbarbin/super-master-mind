(*********************************************************************************)
(*  super-master-mind: A solver for the super master mind game                   *)
(*  SPDX-FileCopyrightText: 2021-2025 Mathieu Barbin <mathieu.barbin@gmail.com>  *)
(*  SPDX-License-Identifier: MIT                                                 *)
(*********************************************************************************)

include Stdlib.ListLabels

let rec drop_while li ~f =
  match li with
  | x :: l when f x -> drop_while l ~f
  | rest -> rest
;;

let equal eq t1 t2 = equal ~eq t1 t2

let is_empty = function
  | [] -> true
  | _ :: _ -> false
;;

let iter t ~f = iter ~f t
let fold t ~init ~f = fold_left t ~init ~f
