(*********************************************************************************)
(*  super-master-mind: A solver for the super master mind game                   *)
(*  SPDX-FileCopyrightText: 2021-2025 Mathieu Barbin <mathieu.barbin@gmail.com>  *)
(*  SPDX-License-Identifier: MIT                                                 *)
(*********************************************************************************)

let%expect_test "verify" =
  let candidate = Code.create_exn [| Green; Blue; Orange; White; Red |] in
  let possible_solutions = Codes.all in
  let guess = Guess.compute ~possible_solutions ~candidate in
  let test guess =
    match Guess.verify guess ~possible_solutions with
    | Ok () -> print_dyn (Dyn.variant "Ok" [ Dyn.unit () ])
    | Error error -> Guess.Verify_error.print_hum error Out_channel.stdout
  in
  test guess;
  [%expect {| Ok () |}];
  (* Unexpected values at the top level of [t]. *)
  test { guess with expected_bits_gained = 3.14 };
  [%expect
    {|
    Unexpected values:
    -1,5 +1,5
      { candidate = [| Green;  Blue;  Orange;  White;  Red |]
    -|; expected_bits_gained = 3.23155340586
    +|; expected_bits_gained = 3.14
      ; expected_bits_remaining = 11.7684465941
      ; min_bits_gained = 2.2125055003
      ; max_bits_gained = 15.
    |}];
  (* Mismatch in the length of by_cues cases. *)
  test
    { guess with
      by_cue = Nonempty_list.cons (Nonempty_list.hd guess.by_cue) guess.by_cue
    };
  [%expect
    {|
    Unexpected by_cue length:
    -1,1 +1,1
    -|20
    +|21 |}];
  (* Mismatch in one of the by_cues. *)
  test
    { guess with
      by_cue =
        Nonempty_list.(
          { (hd guess.by_cue) with size_remaining = 7071 } :: tl guess.by_cue)
    };
  [%expect
    {|
    Unexpected by_cue:
    -1,5 +1,5
      { cue = { white = 2; black = 0 }
    -|; size_remaining = 7070
    +|; size_remaining = 7071
      ; bits_remaining = 12.7874944997
      ; bits_gained = 2.2125055003
      ; probability = 0.215759277344
    |}];
  ()
;;

let%expect_test "no repetition" =
  let candidate = Code.create_exn [| Green; Blue; Orange; White; Red |] in
  let possible_solutions = Codes.all in
  let guess = Guess.compute ~possible_solutions ~candidate in
  print_dyn (Guess.to_dyn guess);
  [%expect
    {|
    { candidate = [| Green;  Blue;  Orange;  White;  Red |]
    ; expected_bits_gained = 3.23155340586
    ; expected_bits_remaining = 11.7684465941
    ; min_bits_gained = 2.2125055003
    ; max_bits_gained = 15.
    ; max_bits_remaining = 12.7874944997
    ; by_cue =
        [ { cue = { white = 2; black = 0 }
          ; size_remaining = 7070
          ; bits_remaining = 12.7874944997
          ; bits_gained = 2.2125055003
          ; probability = 0.215759277344
          ; next_best_guesses = Not_computed
          }
        ; { cue = { white = 3; black = 0 }
          ; size_remaining = 5610
          ; bits_remaining = 12.4537850555
          ; bits_gained = 2.5462149445
          ; probability = 0.171203613281
          ; next_best_guesses = Not_computed
          }
        ; { cue = { white = 1; black = 1 }
          ; size_remaining = 4880
          ; bits_remaining = 12.2526654325
          ; bits_gained = 2.74733456755
          ; probability = 0.14892578125
          ; next_best_guesses = Not_computed
          }
        ; { cue = { white = 2; black = 1 }
          ; size_remaining = 4680
          ; bits_remaining = 12.1922928145
          ; bits_gained = 2.80770718553
          ; probability = 0.142822265625
          ; next_best_guesses = Not_computed
          }
        ; { cue = { white = 1; black = 0 }
          ; size_remaining = 2625
          ; bits_remaining = 11.3581017074
          ; bits_gained = 3.64189829256
          ; probability = 0.0801086425781
          ; next_best_guesses = Not_computed
          }
        ; { cue = { white = 1; black = 2 }
          ; size_remaining = 1650
          ; bits_remaining = 10.6882503091
          ; bits_gained = 4.31174969087
          ; probability = 0.0503540039062
          ; next_best_guesses = Not_computed
          }
        ; { cue = { white = 0; black = 1 }
          ; size_remaining = 1280
          ; bits_remaining = 10.3219280949
          ; bits_gained = 4.67807190511
          ; probability = 0.0390625
          ; next_best_guesses = Not_computed
          }
        ; { cue = { white = 0; black = 2 }
          ; size_remaining = 1250
          ; bits_remaining = 10.2877123795
          ; bits_gained = 4.71228762045
          ; probability = 0.0381469726562
          ; next_best_guesses = Not_computed
          }
        ; { cue = { white = 4; black = 0 }
          ; size_remaining = 1215
          ; bits_remaining = 10.2467405985
          ; bits_gained = 4.75325940151
          ; probability = 0.0370788574219
          ; next_best_guesses = Not_computed
          }
        ; { cue = { white = 3; black = 1 }
          ; size_remaining = 1120
          ; bits_remaining = 10.1292830169
          ; bits_gained = 4.87071698306
          ; probability = 0.0341796875
          ; next_best_guesses = Not_computed
          }
        ; { cue = { white = 2; black = 2 }
          ; size_remaining = 510
          ; bits_remaining = 8.99435343686
          ; bits_gained = 6.00564656314
          ; probability = 0.0155639648438
          ; next_best_guesses = Not_computed
          }
        ; { cue = { white = 0; black = 3 }
          ; size_remaining = 360
          ; bits_remaining = 8.49185309633
          ; bits_gained = 6.50814690367
          ; probability = 0.010986328125
          ; next_best_guesses = Not_computed
          }
        ; { cue = { white = 0; black = 0 }
          ; size_remaining = 243
          ; bits_remaining = 7.92481250361
          ; bits_gained = 7.07518749639
          ; probability = 0.00741577148438
          ; next_best_guesses = Not_computed
          }
        ; { cue = { white = 1; black = 3 }
          ; size_remaining = 120
          ; bits_remaining = 6.90689059561
          ; bits_gained = 8.09310940439
          ; probability = 0.003662109375
          ; next_best_guesses = Not_computed
          }
        ; { cue = { white = 4; black = 1 }
          ; size_remaining = 45
          ; bits_remaining = 5.49185309633
          ; bits_gained = 9.50814690367
          ; probability = 0.00137329101562
          ; next_best_guesses = Not_computed
          }
        ; { cue = { white = 5; black = 0 }
          ; size_remaining = 44
          ; bits_remaining = 5.45943161864
          ; bits_gained = 9.54056838136
          ; probability = 0.0013427734375
          ; next_best_guesses = Not_computed
          }
        ; { cue = { white = 0; black = 4 }
          ; size_remaining = 35
          ; bits_remaining = 5.12928301694
          ; bits_gained = 9.87071698306
          ; probability = 0.00106811523438
          ; next_best_guesses = Not_computed
          }
        ; { cue = { white = 3; black = 2 }
          ; size_remaining = 20
          ; bits_remaining = 4.32192809489
          ; bits_gained = 10.6780719051
          ; probability = 0.0006103515625
          ; next_best_guesses = Not_computed
          }
        ; { cue = { white = 2; black = 3 }
          ; size_remaining = 10
          ; bits_remaining = 3.32192809489
          ; bits_gained = 11.6780719051
          ; probability = 0.00030517578125
          ; next_best_guesses = Not_computed
          }
        ; { cue = { white = 0; black = 5 }
          ; size_remaining = 1
          ; bits_remaining = 0.
          ; bits_gained = 15.
          ; probability = 3.0517578125e-05
          ; next_best_guesses = Not_computed
          }
        ]
    }
    |}];
  (* Due to the symmetry of the game, choosing different colors yields
     the same expected values. *)
  let guess2 =
    Guess.compute
      ~possible_solutions
      ~candidate:(Code.create_exn [| Black; Blue; Brown; Green; Orange |])
  in
  print_dyn (Dyn.bool (Guess.equal guess { guess2 with candidate = guess.candidate }));
  [%expect {| true |}]
;;

let%expect_test "color present 2 times" =
  let candidate = Code.create_exn [| Green; Green; Orange; White; Red |] in
  let possible_solutions = Codes.all in
  let guess = Guess.compute ~possible_solutions ~candidate in
  print_dyn (Guess.to_dyn guess);
  [%expect
    {|
    { candidate = [| Green;  Green;  Orange;  White;  Red |]
    ; expected_bits_gained = 3.23830783701
    ; expected_bits_remaining = 11.761692163
    ; min_bits_gained = 2.21638783474
    ; max_bits_gained = 15.
    ; max_bits_remaining = 12.7836121653
    ; by_cue =
        [ { cue = { white = 2; black = 0 }
          ; size_remaining = 7051
          ; bits_remaining = 12.7836121653
          ; bits_gained = 2.21638783474
          ; probability = 0.215179443359
          ; next_best_guesses = Not_computed
          }
        ; { cue = { white = 1; black = 1 }
          ; size_remaining = 5432
          ; bits_remaining = 12.4072677642
          ; bits_gained = 2.59273223576
          ; probability = 0.165771484375
          ; next_best_guesses = Not_computed
          }
        ; { cue = { white = 1; black = 0 }
          ; size_remaining = 5196
          ; bits_remaining = 12.3431857154
          ; bits_gained = 2.65681428455
          ; probability = 0.158569335938
          ; next_best_guesses = Not_computed
          }
        ; { cue = { white = 2; black = 1 }
          ; size_remaining = 3510
          ; bits_remaining = 11.7772553152
          ; bits_gained = 3.22274468481
          ; probability = 0.107116699219
          ; next_best_guesses = Not_computed
          }
        ; { cue = { white = 3; black = 0 }
          ; size_remaining = 3095
          ; bits_remaining = 11.5957236941
          ; bits_gained = 3.4042763059
          ; probability = 0.0944519042969
          ; next_best_guesses = Not_computed
          }
        ; { cue = { white = 0; black = 1 }
          ; size_remaining = 2387
          ; bits_remaining = 11.2209828511
          ; bits_gained = 3.77901714892
          ; probability = 0.0728454589844
          ; next_best_guesses = Not_computed
          }
        ; { cue = { white = 0; black = 2 }
          ; size_remaining = 1523
          ; bits_remaining = 10.5727002265
          ; bits_gained = 4.42729977351
          ; probability = 0.0464782714844
          ; next_best_guesses = Not_computed
          }
        ; { cue = { white = 1; black = 2 }
          ; size_remaining = 1497
          ; bits_remaining = 10.5478585061
          ; bits_gained = 4.45214149394
          ; probability = 0.0456848144531
          ; next_best_guesses = Not_computed
          }
        ; { cue = { white = 0; black = 0 }
          ; size_remaining = 1024
          ; bits_remaining = 10.
          ; bits_gained = 5.
          ; probability = 0.03125
          ; next_best_guesses = Not_computed
          }
        ; { cue = { white = 3; black = 1 }
          ; size_remaining = 652
          ; bits_remaining = 9.34872815423
          ; bits_gained = 5.65127184577
          ; probability = 0.0198974609375
          ; next_best_guesses = Not_computed
          }
        ; { cue = { white = 4; black = 0 }
          ; size_remaining = 429
          ; bits_remaining = 8.7448338375
          ; bits_gained = 6.2551661625
          ; probability = 0.0130920410156
          ; next_best_guesses = Not_computed
          }
        ; { cue = { white = 2; black = 2 }
          ; size_remaining = 396
          ; bits_remaining = 8.62935662008
          ; bits_gained = 6.37064337992
          ; probability = 0.0120849609375
          ; next_best_guesses = Not_computed
          }
        ; { cue = { white = 0; black = 3 }
          ; size_remaining = 373
          ; bits_remaining = 8.54303182026
          ; bits_gained = 6.45696817974
          ; probability = 0.0113830566406
          ; next_best_guesses = Not_computed
          }
        ; { cue = { white = 1; black = 3 }
          ; size_remaining = 108
          ; bits_remaining = 6.75488750216
          ; bits_gained = 8.24511249784
          ; probability = 0.0032958984375
          ; next_best_guesses = Not_computed
          }
        ; { cue = { white = 0; black = 4 }
          ; size_remaining = 35
          ; bits_remaining = 5.12928301694
          ; bits_gained = 9.87071698306
          ; probability = 0.00106811523438
          ; next_best_guesses = Not_computed
          }
        ; { cue = { white = 4; black = 1 }
          ; size_remaining = 24
          ; bits_remaining = 4.58496250072
          ; bits_gained = 10.4150374993
          ; probability = 0.000732421875
          ; next_best_guesses = Not_computed
          }
        ; { cue = { white = 3; black = 2 }
          ; size_remaining = 14
          ; bits_remaining = 3.80735492206
          ; bits_gained = 11.1926450779
          ; probability = 0.00042724609375
          ; next_best_guesses = Not_computed
          }
        ; { cue = { white = 5; black = 0 }
          ; size_remaining = 12
          ; bits_remaining = 3.58496250072
          ; bits_gained = 11.4150374993
          ; probability = 0.0003662109375
          ; next_best_guesses = Not_computed
          }
        ; { cue = { white = 2; black = 3 }
          ; size_remaining = 9
          ; bits_remaining = 3.16992500144
          ; bits_gained = 11.8300749986
          ; probability = 0.000274658203125
          ; next_best_guesses = Not_computed
          }
        ; { cue = { white = 0; black = 5 }
          ; size_remaining = 1
          ; bits_remaining = 0.
          ; bits_gained = 15.
          ; probability = 3.0517578125e-05
          ; next_best_guesses = Not_computed
          }
        ]
    }
    |}];
  let guess2 =
    Guess.compute
      ~possible_solutions
      ~candidate:(Code.create_exn [| Orange; White; Red; Green; Green |])
  in
  print_dyn (Dyn.bool (Guess.equal guess { guess2 with candidate = guess.candidate }));
  [%expect {| true |}]
;;

let%expect_test "color present 3 times" =
  let candidate = Code.create_exn [| Green; Green; Green; White; Red |] in
  let possible_solutions = Codes.all in
  let guess = Guess.compute ~possible_solutions ~candidate in
  print_dyn (Guess.to_dyn guess);
  [%expect
    {|
    { candidate = [| Green;  Green;  Green;  White;  Red |]
    ; expected_bits_gained = 3.06286950791
    ; expected_bits_remaining = 11.9371304921
    ; min_bits_gained = 2.04144728457
    ; max_bits_gained = 15.
    ; max_bits_remaining = 12.9585527154
    ; by_cue =
        [ { cue = { white = 1; black = 0 }
          ; size_remaining = 7960
          ; bits_remaining = 12.9585527154
          ; bits_gained = 2.04144728457
          ; probability = 0.242919921875
          ; next_best_guesses = Not_computed
          }
        ; { cue = { white = 1; black = 1 }
          ; size_remaining = 5436
          ; bits_remaining = 12.4083297408
          ; bits_gained = 2.59167025923
          ; probability = 0.165893554688
          ; next_best_guesses = Not_computed
          }
        ; { cue = { white = 2; black = 0 }
          ; size_remaining = 4890
          ; bits_remaining = 12.2556187498
          ; bits_gained = 2.74438125016
          ; probability = 0.149230957031
          ; next_best_guesses = Not_computed
          }
        ; { cue = { white = 0; black = 1 }
          ; size_remaining = 4467
          ; bits_remaining = 12.1250905393
          ; bits_gained = 2.8749094607
          ; probability = 0.136322021484
          ; next_best_guesses = Not_computed
          }
        ; { cue = { white = 0; black = 0 }
          ; size_remaining = 3125
          ; bits_remaining = 11.6096404744
          ; bits_gained = 3.39035952556
          ; probability = 0.0953674316406
          ; next_best_guesses = Not_computed
          }
        ; { cue = { white = 0; black = 2 }
          ; size_remaining = 2014
          ; bits_remaining = 10.975847968
          ; bits_gained = 4.02415203199
          ; probability = 0.0614624023438
          ; next_best_guesses = Not_computed
          }
        ; { cue = { white = 2; black = 1 }
          ; size_remaining = 1892
          ; bits_remaining = 10.8856963733
          ; bits_gained = 4.11430362666
          ; probability = 0.0577392578125
          ; next_best_guesses = Not_computed
          }
        ; { cue = { white = 1; black = 2 }
          ; size_remaining = 1179
          ; bits_remaining = 10.203348003
          ; bits_gained = 4.79665199702
          ; probability = 0.0359802246094
          ; next_best_guesses = Not_computed
          }
        ; { cue = { white = 3; black = 0 }
          ; size_remaining = 796
          ; bits_remaining = 9.63662462054
          ; bits_gained = 5.36337537946
          ; probability = 0.0242919921875
          ; next_best_guesses = Not_computed
          }
        ; { cue = { white = 0; black = 3 }
          ; size_remaining = 399
          ; bits_remaining = 8.64024493622
          ; bits_gained = 6.35975506378
          ; probability = 0.0121765136719
          ; next_best_guesses = Not_computed
          }
        ; { cue = { white = 2; black = 2 }
          ; size_remaining = 231
          ; bits_remaining = 7.85174904142
          ; bits_gained = 7.14825095858
          ; probability = 0.00704956054688
          ; next_best_guesses = Not_computed
          }
        ; { cue = { white = 3; black = 1 }
          ; size_remaining = 204
          ; bits_remaining = 7.67242534197
          ; bits_gained = 7.32757465803
          ; probability = 0.0062255859375
          ; next_best_guesses = Not_computed
          }
        ; { cue = { white = 1; black = 3 }
          ; size_remaining = 84
          ; bits_remaining = 6.39231742278
          ; bits_gained = 8.60768257722
          ; probability = 0.0025634765625
          ; next_best_guesses = Not_computed
          }
        ; { cue = { white = 4; black = 0 }
          ; size_remaining = 36
          ; bits_remaining = 5.16992500144
          ; bits_gained = 9.83007499856
          ; probability = 0.0010986328125
          ; next_best_guesses = Not_computed
          }
        ; { cue = { white = 0; black = 4 }
          ; size_remaining = 35
          ; bits_remaining = 5.12928301694
          ; bits_gained = 9.87071698306
          ; probability = 0.00106811523438
          ; next_best_guesses = Not_computed
          }
        ; { cue = { white = 2; black = 3 }
          ; size_remaining = 7
          ; bits_remaining = 2.80735492206
          ; bits_gained = 12.1926450779
          ; probability = 0.000213623046875
          ; next_best_guesses = Not_computed
          }
        ; { cue = { white = 3; black = 2 }
          ; size_remaining = 6
          ; bits_remaining = 2.58496250072
          ; bits_gained = 12.4150374993
          ; probability = 0.00018310546875
          ; next_best_guesses = Not_computed
          }
        ; { cue = { white = 4; black = 1 }
          ; size_remaining = 6
          ; bits_remaining = 2.58496250072
          ; bits_gained = 12.4150374993
          ; probability = 0.00018310546875
          ; next_best_guesses = Not_computed
          }
        ; { cue = { white = 0; black = 5 }
          ; size_remaining = 1
          ; bits_remaining = 0.
          ; bits_gained = 15.
          ; probability = 3.0517578125e-05
          ; next_best_guesses = Not_computed
          }
        ]
    }
    |}];
  let guess2 =
    Guess.compute
      ~possible_solutions
      ~candidate:(Code.create_exn [| White; Red; Green; Green; Green |])
  in
  print_dyn (Dyn.bool (Guess.equal guess { guess2 with candidate = guess.candidate }));
  [%expect {| true |}]
;;

let%expect_test "color present 4 times" =
  let candidate = Code.create_exn [| Green; Green; Green; White; Green |] in
  let possible_solutions = Codes.all in
  let guess = Guess.compute ~possible_solutions ~candidate in
  print_dyn (Guess.to_dyn guess);
  [%expect
    {|
    { candidate = [| Green;  Green;  Green;  White;  Green |]
    ; expected_bits_gained = 2.64203961423
    ; expected_bits_remaining = 12.3579603858
    ; min_bits_gained = 2.04762274803
    ; max_bits_gained = 15.
    ; max_bits_remaining = 12.952377252
    ; by_cue =
        [ { cue = { white = 1; black = 0 }
          ; size_remaining = 7926
          ; bits_remaining = 12.952377252
          ; bits_gained = 2.04762274803
          ; probability = 0.241882324219
          ; next_best_guesses = Not_computed
          }
        ; { cue = { white = 0; black = 0 }
          ; size_remaining = 7776
          ; bits_remaining = 12.9248125036
          ; bits_gained = 2.07518749639
          ; probability = 0.2373046875
          ; next_best_guesses = Not_computed
          }
        ; { cue = { white = 0; black = 1 }
          ; size_remaining = 7585
          ; bits_remaining = 12.8889334651
          ; bits_gained = 2.11106653487
          ; probability = 0.231475830078
          ; next_best_guesses = Not_computed
          }
        ; { cue = { white = 1; black = 1 }
          ; size_remaining = 3912
          ; bits_remaining = 11.933690655
          ; bits_gained = 3.06630934505
          ; probability = 0.119384765625
          ; next_best_guesses = Not_computed
          }
        ; { cue = { white = 0; black = 2 }
          ; size_remaining = 2668
          ; bits_remaining = 11.3815429512
          ; bits_gained = 3.61845704882
          ; probability = 0.0814208984375
          ; next_best_guesses = Not_computed
          }
        ; { cue = { white = 2; black = 0 }
          ; size_remaining = 1105
          ; bits_remaining = 10.1098306543
          ; bits_gained = 4.89016934572
          ; probability = 0.0337219238281
          ; next_best_guesses = Not_computed
          }
        ; { cue = { white = 1; black = 2 }
          ; size_remaining = 684
          ; bits_remaining = 9.41785251489
          ; bits_gained = 5.58214748511
          ; probability = 0.0208740234375
          ; next_best_guesses = Not_computed
          }
        ; { cue = { white = 2; black = 1 }
          ; size_remaining = 508
          ; bits_remaining = 8.98868468677
          ; bits_gained = 6.01131531323
          ; probability = 0.0155029296875
          ; next_best_guesses = Not_computed
          }
        ; { cue = { white = 0; black = 3 }
          ; size_remaining = 438
          ; bits_remaining = 8.7747870596
          ; bits_gained = 6.2252129404
          ; probability = 0.0133666992188
          ; next_best_guesses = Not_computed
          }
        ; { cue = { white = 2; black = 2 }
          ; size_remaining = 78
          ; bits_remaining = 6.28540221886
          ; bits_gained = 8.71459778114
          ; probability = 0.00238037109375
          ; next_best_guesses = Not_computed
          }
        ; { cue = { white = 1; black = 3 }
          ; size_remaining = 48
          ; bits_remaining = 5.58496250072
          ; bits_gained = 9.41503749928
          ; probability = 0.00146484375
          ; next_best_guesses = Not_computed
          }
        ; { cue = { white = 0; black = 4 }
          ; size_remaining = 35
          ; bits_remaining = 5.12928301694
          ; bits_gained = 9.87071698306
          ; probability = 0.00106811523438
          ; next_best_guesses = Not_computed
          }
        ; { cue = { white = 2; black = 3 }
          ; size_remaining = 4
          ; bits_remaining = 2.
          ; bits_gained = 13.
          ; probability = 0.0001220703125
          ; next_best_guesses = Not_computed
          }
        ; { cue = { white = 0; black = 5 }
          ; size_remaining = 1
          ; bits_remaining = 0.
          ; bits_gained = 15.
          ; probability = 3.0517578125e-05
          ; next_best_guesses = Not_computed
          }
        ]
    }
    |}];
  let guess2 =
    Guess.compute
      ~possible_solutions
      ~candidate:(Code.create_exn [| Red; Red; Green; Red; Red |])
  in
  print_dyn (Dyn.bool (Guess.equal guess { guess2 with candidate = guess.candidate }));
  [%expect {| true |}]
;;

let%expect_test "color present 5 times" =
  let candidate = Code.create_exn [| Green; Green; Green; Green; Green |] in
  let possible_solutions = Codes.all in
  let guess = Guess.compute ~possible_solutions ~candidate in
  print_dyn (Guess.to_dyn guess);
  [%expect
    {|
    { candidate = [| Green;  Green;  Green;  Green;  Green |]
    ; expected_bits_gained = 1.46727374205
    ; expected_bits_remaining = 13.532726258
    ; min_bits_gained = 0.963225389712
    ; max_bits_gained = 15.
    ; max_bits_remaining = 14.0367746103
    ; by_cue =
        [ { cue = { white = 0; black = 0 }
          ; size_remaining = 16807
          ; bits_remaining = 14.0367746103
          ; bits_gained = 0.963225389712
          ; probability = 0.512908935547
          ; next_best_guesses = Not_computed
          }
        ; { cue = { white = 0; black = 1 }
          ; size_remaining = 12005
          ; bits_remaining = 13.5513477831
          ; bits_gained = 1.44865221688
          ; probability = 0.366363525391
          ; next_best_guesses = Not_computed
          }
        ; { cue = { white = 0; black = 2 }
          ; size_remaining = 3430
          ; bits_remaining = 11.7439928611
          ; bits_gained = 3.25600713894
          ; probability = 0.104675292969
          ; next_best_guesses = Not_computed
          }
        ; { cue = { white = 0; black = 3 }
          ; size_remaining = 490
          ; bits_remaining = 8.936637939
          ; bits_gained = 6.063362061
          ; probability = 0.0149536132812
          ; next_best_guesses = Not_computed
          }
        ; { cue = { white = 0; black = 4 }
          ; size_remaining = 35
          ; bits_remaining = 5.12928301694
          ; bits_gained = 9.87071698306
          ; probability = 0.00106811523438
          ; next_best_guesses = Not_computed
          }
        ; { cue = { white = 0; black = 5 }
          ; size_remaining = 1
          ; bits_remaining = 0.
          ; bits_gained = 15.
          ; probability = 3.0517578125e-05
          ; next_best_guesses = Not_computed
          }
        ]
    }
    |}];
  let guess2 =
    Guess.compute
      ~possible_solutions
      ~candidate:(Code.create_exn [| Red; Red; Red; Red; Red |])
  in
  print_dyn (Dyn.bool (Guess.equal guess { guess2 with candidate = guess.candidate }));
  [%expect {| true |}]
;;
