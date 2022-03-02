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
