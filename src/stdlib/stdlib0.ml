(*********************************************************************************)
(*  super-master-mind: A solver for the super master mind game                   *)
(*  SPDX-FileCopyrightText: 2021-2025 Mathieu Barbin <mathieu.barbin@gmail.com>  *)
(*  SPDX-License-Identifier: MIT                                                 *)
(*********************************************************************************)

module Array = Array0
module Code_error = Code_error
module Dyn = Dyn0
module Float = Float0
module Fun = Fun0
module Hashtbl = Hashtbl0
module In_channel = In_channel0
module Int = Int0
module Json = Json
module List = List0
module Nonempty_list = Nonempty_list0
module Option = Option0
module Ordering = Ordering0
module Out_channel = Out_channel0
module Result = Result0
module Source_code_position = Source_code_position
module String = String0

let print pp = Format.printf "%a@." Pp.to_fmt pp
let print_dyn dyn = print (Dyn.pp dyn)
let phys_equal (type a) (x : a) (y : a) = x == y

let require cond =
  if not cond then Code_error.raise "Required condition does not hold." []
;;

let require_does_raise f =
  match f () with
  | _ -> Code_error.raise "Did not raise." []
  | exception e -> print_endline (Printexc.to_string e)
;;

let ( +. ) = Stdlib.( +. )
let ( -. ) = Stdlib.( -. )
let ( *. ) = Stdlib.( *. )
let ( /. ) = Stdlib.( /. )
