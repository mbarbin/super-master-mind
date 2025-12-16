(*********************************************************************************)
(*  super-master-mind: A solver for the super master mind game                   *)
(*  SPDX-FileCopyrightText: 2021-2025 Mathieu Barbin <mathieu.barbin@gmail.com>  *)
(*  SPDX-License-Identifier: MIT                                                 *)
(*********************************************************************************)

type t = Lexing.position =
  { pos_fname : string
  ; pos_lnum : int
  ; pos_bol : int
  ; pos_cnum : int
  }

let to_dyn { pos_fname; pos_lnum; pos_bol; pos_cnum } =
  Dyn.record
    [ "pos_fname", Dyn.string pos_fname
    ; "pos_lnum", Dyn.int pos_lnum
    ; "pos_bol", Dyn.int pos_bol
    ; "pos_cnum", Dyn.int pos_cnum
    ]
;;

let of_pos (file, lnum, cnum, _enum) =
  { pos_fname = file; pos_lnum = lnum; pos_bol = 0; pos_cnum = cnum }
;;
