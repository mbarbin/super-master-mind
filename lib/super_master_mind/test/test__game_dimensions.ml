open! Base
open! Stdio
open Super_master_mind

let%expect_test "set twice" =
  Game_dimensions.use_small_game_dimensions_exn [%here];
  Expect_test_helpers_base.require_does_raise [%here] (fun () ->
    Game_dimensions.use_small_game_dimensions_exn [%here]);
  [%expect
    {|
    ("Game_dimensions is already set"
     lib/super_master_mind/test/test__game_dimensions.ml:8:50
     ((was_set_here lib/super_master_mind/test/test__game_dimensions.ml:6:48))) |}]
;;

let%expect_test "set after use" =
  print_s [%sexp { code_size = (Game_dimensions.code_size [%here] : int) }];
  Expect_test_helpers_base.require_does_raise [%here] (fun () ->
    Game_dimensions.use_small_game_dimensions_exn [%here]);
  [%expect
    {|
    ((code_size 3))
    ("Game_dimensions is already set"
     lib/super_master_mind/test/test__game_dimensions.ml:19:50
     ((was_set_here lib/super_master_mind/test/test__game_dimensions.ml:6:48))) |}]
;;

let%expect_test "defaults" =
  print_s
    [%sexp
      { code_size = (Game_dimensions.code_size [%here] : int)
      ; num_colors = (Game_dimensions.num_colors [%here] : int)
      }];
  [%expect {| ((code_size 3) (num_colors 4)) |}]
;;
