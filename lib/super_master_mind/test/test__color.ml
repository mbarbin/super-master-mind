open! Core
open Super_master_mind

let%expect_test "sexp_of_t" =
  print_s [%sexp (Color.cardinality : int)];
  [%expect {| 8 |}];
  assert (Color.cardinality = List.length Color.all);
  List.iter Color.all ~f:(fun t -> print_s [%sexp (t : Color.t)]);
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
  List.iter Color.all ~f:(fun color ->
    let index = Color.to_index color in
    let color' = Color.of_index_exn index in
    assert (Color.equal color color'));
  [%expect {||}];
  Expect_test_helpers_core.require_does_raise [%here] (fun () ->
    ignore (Color.of_index_exn Color.cardinality : Color.t));
  [%expect {| ("Index out of bounds" src/color.ml:52:45 8) |}];
  ()
;;

let%expect_test "hum" =
  List.iter Color.Hum.all ~f:(fun hum ->
    let color = Color.of_hum hum in
    let hum' = Color.to_hum color in
    assert (Color.Hum.equal hum hum'));
  [%expect {||}]
;;
