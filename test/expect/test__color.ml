(*********************************************************************************)
(*  super-master-mind: A solver for the super master mind game                   *)
(*  SPDX-FileCopyrightText: 2021-2025 Mathieu Barbin <mathieu.barbin@gmail.com>  *)
(*  SPDX-License-Identifier: MIT                                                 *)
(*********************************************************************************)

let%expect_test "to_dyn" =
  print_dyn (Dyn.int (Lazy.force Color.cardinality));
  [%expect {| 8 |}];
  assert (Lazy.force Color.cardinality = List.length (Lazy.force Color.all));
  List.iter (Lazy.force Color.all) ~f:(fun t -> print_dyn (Color.to_dyn t));
  [%expect
    {|
    Black
    Blue
    Brown
    Green
    Orange
    Red
    White
    Yellow |}]
;;

let%expect_test "indices" =
  List.iter (Lazy.force Color.all) ~f:(fun color ->
    let index = Color.to_index color in
    let color' = Color.of_index_exn index in
    assert (Color.equal color color'));
  [%expect {||}];
  require_does_raise (fun () : Color.t ->
    Color.of_index_exn (Lazy.force Color.cardinality));
  [%expect {| ("Index out of bounds.", { index = 8; cardinality = 8 }) |}];
  ()
;;

let%expect_test "hum" =
  List.iter Color.Hum.all ~f:(fun hum ->
    let color = Color.of_hum hum in
    let hum' = Color.to_hum color in
    assert (Color.Hum.equal hum hum'));
  [%expect {||}]
;;
