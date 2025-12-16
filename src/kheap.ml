(*********************************************************************************)
(*  super-master-mind: A solver for the super master mind game                   *)
(*  SPDX-FileCopyrightText: 2021-2025 Mathieu Barbin <mathieu.barbin@gmail.com>  *)
(*  SPDX-License-Identifier: MIT                                                 *)
(*********************************************************************************)

module Node = struct
  type 'a t =
    { value : 'a
    ; mutable tail : 'a t option
    }

  let[@tail_mod_cons] rec to_list = function
    | None -> []
    | Some (t : _ t) ->
      (* We disable coverage in the second part of the expression because the
         instrumentation breaks [@tail_mod_cons], triggering [warning 71]. *)
      t.value :: (to_list t.tail [@coverage off])
  ;;
end

type 'a t =
  { k : int
  ; compare : 'a -> 'a -> int
  ; mutable head : 'a Node.t option
  }

let create ~k ~compare =
  assert (k > 0);
  { k; compare; head = None }
;;

let to_list t = Node.to_list t.head
let to_dyn to_dyn_a t = Dyn.list to_dyn_a (to_list t)

let rec cut node ~k =
  match node with
  | None -> None
  | Some ({ Node.value = _; tail } as t) ->
    if k = 0
    then None
    else (
      t.tail <- cut tail ~k:(Int.pred k);
      node)
;;

let add t a =
  let rec aux k = function
    | None -> if k >= 1 then Some { Node.value = a; tail = None } else None
    | Some (node : _ Node.t) as head ->
      (match Ordering.of_int (t.compare node.value a) with
       | Gt ->
         (* Insert [a] before [node.value]. *)
         let tail = cut head ~k:(Int.pred k) in
         Some { Node.value = a; tail }
       | Eq | Lt ->
         (* Insert [a] after [node.value]. *)
         node.tail <- aux (Int.pred k) node.tail;
         head)
  in
  t.head <- aux t.k t.head
;;
