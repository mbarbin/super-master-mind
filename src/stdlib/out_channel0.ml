(*********************************************************************************)
(*  super-master-mind: A solver for the super master mind game                   *)
(*  SPDX-FileCopyrightText: 2021-2025 Mathieu Barbin <mathieu.barbin@gmail.com>  *)
(*  SPDX-License-Identifier: MIT                                                 *)
(*********************************************************************************)

include Stdlib.Out_channel

let output_lines t lines =
  Stdlib.ListLabels.iter lines ~f:(fun line ->
    output_string t line;
    output_char t '\n')
;;

let with_open_text t ~f = with_open_text t f
