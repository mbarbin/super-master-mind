open! Core
open Super_master_mind

let%expect_test "sexp_of_t" =
  print_s [%sexp (force Cue.cardinality : int)];
  [%expect {| 20 |}];
  assert (force Cue.cardinality = List.length (force Cue.all));
  List.iter (force Cue.all) ~f:(fun t -> print_s [%sexp (t : Cue.t)]);
  [%expect
    {|
    ((white 0) (black 0))
    ((white 0) (black 1))
    ((white 0) (black 2))
    ((white 0) (black 3))
    ((white 0) (black 4))
    ((white 0) (black 5))
    ((white 1) (black 0))
    ((white 1) (black 1))
    ((white 1) (black 2))
    ((white 1) (black 3))
    ((white 2) (black 0))
    ((white 2) (black 1))
    ((white 2) (black 2))
    ((white 2) (black 3))
    ((white 3) (black 0))
    ((white 3) (black 1))
    ((white 3) (black 2))
    ((white 4) (black 0))
    ((white 4) (black 1))
    ((white 5) (black 0)) |}]
;;

let%expect_test "indices" =
  List.iter (force Cue.all) ~f:(fun cue ->
    let index = Cue.to_index cue in
    let cue' = Cue.of_index_exn index in
    assert (Cue.equal cue cue'));
  [%expect {||}];
  Expect_test_helpers_core.require_does_raise [%here] (fun () ->
    ignore (Cue.of_index_exn (force Cue.cardinality) : Cue.t));
  [%expect {| ("Index out of bounds" lib/super_master_mind/src/cue.ml:88:45 20) |}];
  ()
;;

let%expect_test "hum" =
  List.iter (force Cue.all) ~f:(fun cue ->
    let hum = Cue.to_hum cue in
    let cue' = Cue.create_exn hum in
    assert (Cue.equal cue cue'));
  [%expect {||}];
  Expect_test_helpers_core.require_does_raise [%here] (fun () ->
    ignore (Cue.create_exn { white = 3; black = 3 } : Cue.t));
  [%expect
    {|
    ("Invalid hum representation"
     lib/super_master_mind/src/cue.ml:97:57
     ((white 3)
      (black 3))) |}];
  ()
;;
