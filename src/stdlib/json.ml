(*********************************************************************************)
(*  super-master-mind: A solver for the super master mind game                   *)
(*  SPDX-FileCopyrightText: 2021-2025 Mathieu Barbin <mathieu.barbin@gmail.com>  *)
(*  SPDX-License-Identifier: MIT                                                 *)
(*********************************************************************************)

type t = Yojson.Basic.t

exception Invalid_json of string * t
exception Parse_error of string

let load ~file =
  try Yojson.Basic.from_file file with
  | Yojson.Json_error msg -> raise (Parse_error msg)
;;

let save t ~file =
  Out_channel.with_open_text file (fun oc ->
    Yojson.Basic.pretty_to_channel ~std:true oc t;
    Out_channel.output_char oc '\n')
;;

let to_string t = Yojson.Basic.pretty_to_string ~std:true t

let of_string s =
  try Yojson.Basic.from_string s with
  | Yojson.Json_error msg -> raise (Parse_error msg)
;;

let () =
  Printexc.register_printer (function
    | Invalid_json (msg, json) ->
      Some (Printf.sprintf "Json.Invalid_json(%S, %s)" msg (Yojson.Basic.to_string json))
    | Parse_error msg -> Some (Printf.sprintf "Json.Parse_error(%S)" msg)
    | _ -> None [@coverage off])
;;
