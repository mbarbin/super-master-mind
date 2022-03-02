open! Core
open Super_master_mind

let%expect_test "sexp_of_t" =
  print_s [%sexp (Cue.cardinality : int)];
  [%expect {| 21 |}];
  assert (Cue.cardinality = List.length Cue.all);
  List.iter Cue.all ~f:(fun t -> print_s [%sexp (t : Cue.t)]);
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
    ((white 1) (black 4))
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
