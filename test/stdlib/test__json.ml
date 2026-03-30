(*********************************************************************************)
(*  super-master-mind: A solver for the super master mind game                   *)
(*  SPDX-FileCopyrightText: 2021-2025 Mathieu Barbin <mathieu.barbin@gmail.com>  *)
(*  SPDX-License-Identifier: MIT                                                 *)
(*********************************************************************************)

let%expect_test "load - parse error" =
  require_does_raise (fun () -> Json.load ~file:"/dev/null");
  [%expect {| Json.Parse_error("Blank input data") |}];
  ()
;;
