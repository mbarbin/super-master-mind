(*********************************************************************************)
(*  super-master-mind: A solver for the super master mind game                   *)
(*  SPDX-FileCopyrightText: 2021-2025 Mathieu Barbin <mathieu.barbin@gmail.com>  *)
(*  SPDX-License-Identifier: MIT                                                 *)
(*********************************************************************************)

type t = Yojson.Basic.t

exception Invalid_json of string * t

let load ~file = Yojson.Basic.from_file file

let save t ~file =
  Stdlib.Out_channel.with_open_text file (fun oc ->
    Yojson.Basic.pretty_to_channel ~std:true oc t;
    Stdlib.Out_channel.output_char oc '\n')
;;

let to_string t = Yojson.Basic.pretty_to_string ~std:true t
