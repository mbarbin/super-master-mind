(*********************************************************************************)
(*  super-master-mind: A solver for the super master mind game                   *)
(*  SPDX-FileCopyrightText: 2021-2025 Mathieu Barbin <mathieu.barbin@gmail.com>  *)
(*  SPDX-License-Identifier: MIT                                                 *)
(*********************************************************************************)

let%expect_test "set twice" =
  Game_dimensions.use_small_game_dimensions_exn
    (Source_code_position.of_pos Stdlib.__POS__);
  require_does_raise (fun () ->
    Game_dimensions.use_small_game_dimensions_exn
      (Source_code_position.of_pos Stdlib.__POS__));
  [%expect
    {|
    ("Game_dimensions is already set.",
     { here = { pos_fname = ""; pos_lnum = 12; pos_bol = 0; pos_cnum = 35 }
     ; was_set_here =
         { pos_fname = ""; pos_lnum = 9; pos_bol = 0; pos_cnum = 33 }
     })
    |}]
;;

let%expect_test "set after use" =
  print_dyn
    (Dyn.record
       [ ( "code_size"
         , Dyn.int
             (Game_dimensions.code_size (Source_code_position.of_pos Stdlib.__POS__)) )
       ]);
  require_does_raise (fun () ->
    Game_dimensions.use_small_game_dimensions_exn
      (Source_code_position.of_pos Stdlib.__POS__));
  [%expect
    {|
    { code_size = 3 }
    ("Game_dimensions is already set.",
     { here = { pos_fname = ""; pos_lnum = 32; pos_bol = 0; pos_cnum = 35 }
     ; was_set_here =
         { pos_fname = ""; pos_lnum = 9; pos_bol = 0; pos_cnum = 33 }
     })
    |}]
;;

let%expect_test "defaults" =
  print_dyn
    (Dyn.record
       [ ( "code_size"
         , Dyn.int
             (Game_dimensions.code_size (Source_code_position.of_pos Stdlib.__POS__)) )
       ; ( "num_colors"
         , Dyn.int
             (Game_dimensions.num_colors (Source_code_position.of_pos Stdlib.__POS__)) )
       ]);
  [%expect {| { code_size = 3; num_colors = 4 } |}]
;;
