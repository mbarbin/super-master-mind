open! Core

let%expect_test "hello" =
  print_s Super_master_mind.Hello.hello_world;
  [%expect {| "Hello, World!" |}]
;;
