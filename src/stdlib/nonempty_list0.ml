(*********************************************************************************)
(*  super-master-mind: A solver for the super master mind game                   *)
(*  SPDX-FileCopyrightText: 2021-2025 Mathieu Barbin <mathieu.barbin@gmail.com>  *)
(*  SPDX-License-Identifier: MIT                                                 *)
(*********************************************************************************)

(* Note: Defining [(::)] as a constructor shadows [Stdlib.(::)] within this
   module. In patterns, the compiler resolves [(::)] based on the expected
   type. In expressions, we use [List.cons] when building regular lists. *)

module List = Stdlib.ListLabels

type 'a t = ( :: ) of 'a * 'a list

let singleton x = x :: []
let hd (hd :: _) = hd
let tl (_ :: tl) = tl
let cons x (hd :: tl) = x :: List.cons hd tl
let to_list (hd :: tl) = List.cons hd tl

let of_list_exn (type a) : a list -> a t = function
  | [] -> invalid_arg "Nonempty_list.of_list_exn"
  | x :: xs -> x :: xs
;;

let to_array t = Stdlib.Array.of_list (to_list t)
let length ((_ : _) :: tl) = 1 + List.length tl

let init n ~f =
  if n <= 0 then invalid_arg "Nonempty_list.init";
  match List.init ~len:n ~f with
  | [] -> assert false
  | x :: xs -> x :: xs
;;

let append (hd :: tl) rest = hd :: (tl @ rest)

let map (x :: xs) ~f =
  let y = f x in
  y :: List.map xs ~f
;;

let mapi t ~f =
  match List.mapi (to_list t) ~f with
  | [] -> assert false
  | x :: xs -> x :: xs
;;

let iter t ~f = List.iter (to_list t) ~f
let fold (hd :: tl) ~init ~f = List.fold_left tl ~init:(f init hd) ~f
let find (hd :: tl) ~f = if f hd then Some hd else List.find_opt tl ~f
let filter t ~f = List.filter (to_list t) ~f
let filter_map t ~f = List.filter_map (to_list t) ~f

let concat_map t ~f =
  match List.concat_map (to_list t) ~f:(fun x -> to_list (f x)) with
  | [] -> assert false
  | x :: xs -> x :: xs
;;

let max_elt (hd :: tl) ~compare =
  List.fold_left tl ~init:hd ~f:(fun acc x ->
    match compare x acc with
    | Ordering.Gt -> x
    | Lt | Eq -> acc)
;;

module type Summable = sig
  type t

  val zero : t
  val ( + ) : t -> t -> t
end

let sum (type a) (module M : Summable with type t = a) t ~f =
  fold t ~init:M.zero ~f:(fun acc x -> M.( + ) acc (f x))
;;

let compare compare_a (hd1 :: tl1) (hd2 :: tl2) =
  match compare_a hd1 hd2 with
  | Ordering.Eq ->
    List.compare tl1 tl2 ~cmp:(fun a b -> compare_a a b |> Ordering.to_int)
    |> Ordering.of_int
  | ord -> ord
;;

let equal equal_a (hd1 :: tl1) (hd2 :: tl2) =
  equal_a hd1 hd2 && List.equal ~eq:equal_a tl1 tl2
;;

module Or_unequal_lengths = struct
  type 'a t =
    | Ok of 'a
    | Unequal_lengths
end

let zip (hd1 :: tl1) (hd2 :: tl2) =
  if List.length tl1 <> List.length tl2
  then Or_unequal_lengths.Unequal_lengths
  else Or_unequal_lengths.Ok ((hd1, hd2) :: List.combine tl1 tl2)
;;
