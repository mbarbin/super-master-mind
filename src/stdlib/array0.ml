(*********************************************************************************)
(*  super-master-mind: A solver for the super master mind game                   *)
(*  SPDX-FileCopyrightText: 2021-2025 Mathieu Barbin <mathieu.barbin@gmail.com>  *)
(*  SPDX-License-Identifier: MIT                                                 *)
(*********************************************************************************)

include Stdlib.ArrayLabels

let equal eq t1 t2 =
  t1 == t2 || (Array.length t1 = Array.length t2 && Array.for_all2 eq t1 t2)
;;

let is_empty t = Array.length t = 0
let create ~len a = Array.make len a

let filter_mapi t ~f =
  t |> Array.to_seqi |> Seq.filter_map (fun (i, x) -> f i x) |> Array.of_seq
;;

let fold t ~init ~f = fold_left t ~init ~f

let foldi t ~init ~f =
  t |> Array.to_seqi |> Seq.fold_left (fun acc (i, e) -> f i acc e) init
;;

let sort t ~compare = sort t ~cmp:(fun a b -> compare a b |> Ordering.to_int)
