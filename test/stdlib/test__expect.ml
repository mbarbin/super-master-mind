(*********************************************************************************)
(*  catch-the-bunny: Resolving a small logic puzzle to catch a bunny             *)
(*  SPDX-FileCopyrightText: 2022-2025 Mathieu Barbin <mathieu.barbin@gmail.com>  *)
(*  SPDX-License-Identifier: MIT                                                 *)
(*********************************************************************************)

let%expect_test "require_does_raise did not raise" =
  (match require_does_raise ignore with
   | () -> assert false
   | exception exn -> print_string (Printexc.to_string exn));
  [%expect {| ("Did not raise.", {}) |}];
  ()
;;
