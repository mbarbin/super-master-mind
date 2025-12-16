(*********************************************************************************)
(*  super-master-mind: A solver for the super master mind game                   *)
(*  SPDX-FileCopyrightText: 2021-2025 Mathieu Barbin <mathieu.barbin@gmail.com>  *)
(*  SPDX-License-Identifier: MIT                                                 *)
(*********************************************************************************)

type t =
  | All
  | Only of { queue : Code.t Queue.t }

let to_dyn = function
  | All -> Dyn.variant "All" []
  | Only { queue } -> Dyn.variant "Only" [ Dyn.list Code.to_dyn (Queue.to_list queue) ]
;;

let all = All

let size = function
  | All -> force Code.cardinality
  | Only { queue } -> Queue.length queue
;;

let bits t = Float.log2 (Float.of_int (size t))

let is_empty = function
  | All -> false
  | Only { queue } -> Queue.is_empty queue
;;

let all_as_queue =
  lazy
    (let code_cardinality = force Code.cardinality in
     let t = Queue.create () in
     let rec aux i =
       if i < code_cardinality
       then (
         Queue.enqueue t (Code.of_index_exn i);
         aux (Int.succ i))
     in
     aux 0;
     t)
;;

let to_list = function
  | All -> Queue.to_list (Lazy.force all_as_queue)
  | Only { queue } -> Queue.to_list queue
;;

let iter t ~f =
  match t with
  | All ->
    for i = 0 to force Code.cardinality - 1 do
      f (Code.of_index_exn i)
    done
  | Only { queue } -> Queue.iter queue ~f
;;

let filter t ~candidate ~cue =
  let queue = Queue.create () in
  iter t ~f:(fun solution ->
    if Cue.equal cue (Code.analyze ~solution ~candidate) then Queue.enqueue queue solution);
  Only { queue }
;;
