(*********************************************************************************)
(*  super-master-mind: A solver for the super master mind game                   *)
(*  SPDX-FileCopyrightText: 2021-2025 Mathieu Barbin <mathieu.barbin@gmail.com>  *)
(*  SPDX-License-Identifier: MIT                                                 *)
(*********************************************************************************)

let%expect_test "set twice" =
  Game_dimensions.use_small_game_dimensions_exn [%here];
  require_does_raise ~hide_positions:true [%here] (fun () ->
    Game_dimensions.use_small_game_dimensions_exn [%here]);
  [%expect {| ("Game_dimensions is already set" :10:50 ((was_set_here :8:48))) |}]
;;

let%expect_test "set after use" =
  print_s [%sexp { code_size = (Game_dimensions.code_size [%here] : int) }];
  require_does_raise ~hide_positions:true [%here] (fun () ->
    Game_dimensions.use_small_game_dimensions_exn [%here]);
  [%expect
    {|
    ((code_size 3))
    ("Game_dimensions is already set" :17:50 ((was_set_here :8:48)))
    |}]
;;

let%expect_test "defaults" =
  print_s
    [%sexp
      { code_size = (Game_dimensions.code_size [%here] : int)
      ; num_colors = (Game_dimensions.num_colors [%here] : int)
      }];
  [%expect
    {|
    ((code_size  3)
     (num_colors 4)) |}]
;;
