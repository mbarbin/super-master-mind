(*********************************************************************************)
(*  super-master-mind: A solver for the super master mind game                   *)
(*  SPDX-FileCopyrightText: 2021-2025 Mathieu Barbin <mathieu.barbin@gmail.com>  *)
(*  SPDX-License-Identifier: MIT                                                 *)
(*********************************************************************************)

let%expect_test "to_dyn" =
  print_dyn (Dyn.int (force Cue.cardinality));
  [%expect {| 20 |}];
  assert (force Cue.cardinality = List.length (force Cue.all));
  List.iter (force Cue.all) ~f:(fun t -> print_dyn (Cue.to_dyn t));
  [%expect
    {|
    { white = 0; black = 0 }
    { white = 0; black = 1 }
    { white = 0; black = 2 }
    { white = 0; black = 3 }
    { white = 0; black = 4 }
    { white = 0; black = 5 }
    { white = 1; black = 0 }
    { white = 1; black = 1 }
    { white = 1; black = 2 }
    { white = 1; black = 3 }
    { white = 2; black = 0 }
    { white = 2; black = 1 }
    { white = 2; black = 2 }
    { white = 2; black = 3 }
    { white = 3; black = 0 }
    { white = 3; black = 1 }
    { white = 3; black = 2 }
    { white = 4; black = 0 }
    { white = 4; black = 1 }
    { white = 5; black = 0 } |}]
;;

let%expect_test "indices" =
  List.iter (force Cue.all) ~f:(fun cue ->
    let index = Cue.to_index cue in
    let cue' = Cue.of_index_exn index in
    assert (Cue.equal cue cue'));
  [%expect {||}];
  require_does_raise (fun () : Cue.t -> Cue.of_index_exn (force Cue.cardinality));
  [%expect {| ("Index out of bounds.", { index = 20; cardinality = 20 }) |}];
  ()
;;

let%expect_test "hum" =
  List.iter (force Cue.all) ~f:(fun cue ->
    let hum = Cue.to_hum cue in
    let cue' = Cue.create_exn hum in
    assert (Cue.equal cue cue'));
  [%expect {||}];
  require_does_raise (fun () : Cue.t -> Cue.create_exn { white = 3; black = 3 });
  [%expect {| ("Invalid cue.", { hum = { white = 3; black = 3 } }) |}];
  ()
;;
