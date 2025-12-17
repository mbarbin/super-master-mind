(*********************************************************************************)
(*  super-master-mind: A solver for the super master mind game                   *)
(*  SPDX-FileCopyrightText: 2021-2025 Mathieu Barbin <mathieu.barbin@gmail.com>  *)
(*  SPDX-License-Identifier: MIT                                                 *)
(*********************************************************************************)

type t =
  | All
  | Only of { codes : Code.t list }

let to_dyn = function
  | All -> Dyn.variant "All" []
  | Only { codes } -> Dyn.variant "Only" [ Dyn.list Code.to_dyn codes ]
;;

let all = All

let size = function
  | All -> Lazy.force Code.cardinality
  | Only { codes } -> List.length codes
;;

let bits t = Float.log2 (Float.of_int (size t))

let is_empty = function
  | All -> false
  | Only { codes } -> List.is_empty codes
;;

let all_as_list =
  lazy
    (let code_cardinality = Lazy.force Code.cardinality in
     let rec aux acc i =
       if i < code_cardinality
       then (
         let acc = Code.of_index_exn i :: acc in
         aux acc (Int.succ i))
       else acc
     in
     List.rev (aux [] 0))
;;

let to_list = function
  | All -> Lazy.force all_as_list
  | Only { codes } -> codes
;;

let iter t ~f =
  match t with
  | All ->
    for i = 0 to Lazy.force Code.cardinality - 1 do
      f (Code.of_index_exn i)
    done
  | Only { codes } -> List.iter codes ~f
;;

let filter t ~candidate ~cue =
  let keep = ref [] in
  iter t ~f:(fun solution ->
    if Cue.equal cue (Code.analyze ~solution ~candidate) then keep := solution :: !keep);
  Only { codes = List.rev !keep }
;;
