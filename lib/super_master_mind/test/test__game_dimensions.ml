open! Core
open! Core
open Super_master_mind

let%expect_test "set twice" =
  Expect_test_helpers_core.require_does_raise [%here] (fun () ->
    Game_dimensions.use_small_game_dimensions_exn [%here];
    Game_dimensions.use_small_game_dimensions_exn [%here]);
  [%expect
    {|
    ("Game_dimensions is already set"
     lib/super_master_mind/test/test__game_dimensions.ml:7:50
     ((was_set_here lib/super_master_mind/src/cue.ml:12:48))) |}]
;;

let%expect_test "set after use" =
  Expect_test_helpers_core.require_does_raise [%here] (fun () ->
    print_s [%sexp { code_size = (Game_dimensions.code_size [%here] : int) }];
    Game_dimensions.use_small_game_dimensions_exn [%here]);
  [%expect
    {|
    ((code_size 5))
    ("Game_dimensions is already set"
     lib/super_master_mind/test/test__game_dimensions.ml:19:50
     ((was_set_here lib/super_master_mind/src/cue.ml:12:48))) |}]
;;

let%expect_test "defaults" =
  print_s
    [%sexp
      { code_size = (Game_dimensions.code_size [%here] : int)
      ; num_colors = (Game_dimensions.num_colors [%here] : int)
      }];
  [%expect {| ((code_size 5) (num_colors 8)) |}]
;;
