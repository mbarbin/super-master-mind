open! Core
open Super_master_mind

let%expect_test "hello" =
  let t = Permutation.create_exn [| Green; Blue; Orange; White; Red |] in
  print_s [%sexp (t : Permutation.t)];
  [%expect {| (Green Blue Orange White Red) |}]
;;
