(*********************************************************************************)
(*  super-master-mind: A solver for the super master mind game                   *)
(*  SPDX-FileCopyrightText: 2021-2025 Mathieu Barbin <mathieu.barbin@gmail.com>  *)
(*  SPDX-License-Identifier: MIT                                                 *)
(*********************************************************************************)

let%expect_test "fold" =
  let sum = Array.fold [| 1; 2; 3 |] ~init:0 ~f:( + ) in
  print_dyn (Dyn.int sum);
  [%expect {| 6 |}];
  ()
;;

let%expect_test "equal - physical equality" =
  let a = [| 1; 2; 3 |] in
  require (Array.equal Int.equal a a);
  [%expect {| |}];
  ()
;;
