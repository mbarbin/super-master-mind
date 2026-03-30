(*********************************************************************************)
(*  super-master-mind: A solver for the super master mind game                   *)
(*  SPDX-FileCopyrightText: 2021-2025 Mathieu Barbin <mathieu.barbin@gmail.com>  *)
(*  SPDX-License-Identifier: MIT                                                 *)
(*********************************************************************************)

let%expect_test "is_empty" =
  require (List.is_empty []);
  require (not (List.is_empty [ 1 ]));
  [%expect {| |}];
  ()
;;
