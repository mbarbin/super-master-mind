(*********************************************************************************)
(*  super-master-mind: A solver for the super master mind game                   *)
(*  SPDX-FileCopyrightText: 2021-2025 Mathieu Barbin <mathieu.barbin@gmail.com>  *)
(*  SPDX-License-Identifier: MIT                                                 *)
(*********************************************************************************)

let%expect_test "to_dyn" =
  print_dyn (Ordering.to_dyn Lt);
  [%expect {| Lt |}];
  print_dyn (Ordering.to_dyn Eq);
  [%expect {| Eq |}];
  print_dyn (Ordering.to_dyn Gt);
  [%expect {| Gt |}];
  ()
;;
