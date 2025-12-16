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
    -|; expected_bits_gained = 3.2315534058559967
    +|; expected_bits_gained = 3.14
      ; expected_bits_remaining = 11.768446594144002
      ; min_bits_gained = 2.2125055003000007
      ; max_bits_gained = 15
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
      ; bits_gained = 2.2125055003000007
      ; probability = 0.21575927734375
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
    ; expected_bits_gained = 3.2315534058559967
    ; expected_bits_remaining = 11.768446594144002
    ; min_bits_gained = 2.2125055003000007
    ; max_bits_gained = 15
    ; max_bits_remaining = 12.7874944997
    ; by_cue =
        [ { cue = { white = 2; black = 0 }
          ; size_remaining = 7070
          ; bits_remaining = 12.7874944997
          ; bits_gained = 2.2125055003000007
          ; probability = 0.21575927734375
          ; next_best_guesses = Not_computed
          }
        ; { cue = { white = 3; black = 0 }
          ; size_remaining = 5610
          ; bits_remaining = 12.4537850555
          ; bits_gained = 2.5462149445000009
          ; probability = 0.17120361328125
          ; next_best_guesses = Not_computed
          }
        ; { cue = { white = 1; black = 1 }
          ; size_remaining = 4880
          ; bits_remaining = 12.2526654325
          ; bits_gained = 2.7473345674999994
          ; probability = 0.14892578125
          ; next_best_guesses = Not_computed
          }
        ; { cue = { white = 2; black = 1 }
          ; size_remaining = 4680
          ; bits_remaining = 12.1922928145
          ; bits_gained = 2.8077071855
          ; probability = 0.142822265625
          ; next_best_guesses = Not_computed
          }
        ; { cue = { white = 1; black = 0 }
          ; size_remaining = 2625
          ; bits_remaining = 11.3581017074
          ; bits_gained = 3.6418982926000005
          ; probability = 0.080108642578125
          ; next_best_guesses = Not_computed
          }
        ; { cue = { white = 1; black = 2 }
          ; size_remaining = 1650
          ; bits_remaining = 10.6882503091
          ; bits_gained = 4.3117496908999993
          ; probability = 0.05035400390625
          ; next_best_guesses = Not_computed
          }
        ; { cue = { white = 0; black = 1 }
          ; size_remaining = 1280
          ; bits_remaining = 10.3219280949
          ; bits_gained = 4.6780719050999995
          ; probability = 0.0390625
          ; next_best_guesses = Not_computed
          }
        ; { cue = { white = 0; black = 2 }
          ; size_remaining = 1250
          ; bits_remaining = 10.2877123795
          ; bits_gained = 4.7122876205
          ; probability = 0.03814697265625
          ; next_best_guesses = Not_computed
          }
        ; { cue = { white = 4; black = 0 }
          ; size_remaining = 1215
          ; bits_remaining = 10.2467405985
          ; bits_gained = 4.7532594014999994
          ; probability = 0.037078857421875
          ; next_best_guesses = Not_computed
          }
        ; { cue = { white = 3; black = 1 }
          ; size_remaining = 1120
          ; bits_remaining = 10.1292830169
          ; bits_gained = 4.8707169830999995
          ; probability = 0.0341796875
          ; next_best_guesses = Not_computed
          }
        ; { cue = { white = 2; black = 2 }
          ; size_remaining = 510
          ; bits_remaining = 8.9943534369
          ; bits_gained = 6.0056465630999991
          ; probability = 0.01556396484375
          ; next_best_guesses = Not_computed
          }
        ; { cue = { white = 0; black = 3 }
          ; size_remaining = 360
          ; bits_remaining = 8.4918530963
          ; bits_gained = 6.5081469037
          ; probability = 0.010986328125
          ; next_best_guesses = Not_computed
          }
        ; { cue = { white = 0; black = 0 }
          ; size_remaining = 243
          ; bits_remaining = 7.9248125036
          ; bits_gained = 7.0751874964
          ; probability = 0.007415771484375
          ; next_best_guesses = Not_computed
          }
        ; { cue = { white = 1; black = 3 }
          ; size_remaining = 120
          ; bits_remaining = 6.9068905956
          ; bits_gained = 8.0931094044
          ; probability = 0.003662109375
          ; next_best_guesses = Not_computed
          }
        ; { cue = { white = 4; black = 1 }
          ; size_remaining = 45
          ; bits_remaining = 5.4918530963
          ; bits_gained = 9.5081469037
          ; probability = 0.001373291015625
          ; next_best_guesses = Not_computed
          }
        ; { cue = { white = 5; black = 0 }
          ; size_remaining = 44
          ; bits_remaining = 5.4594316186
          ; bits_gained = 9.5405683814
          ; probability = 0.0013427734375
          ; next_best_guesses = Not_computed
          }
        ; { cue = { white = 0; black = 4 }
          ; size_remaining = 35
          ; bits_remaining = 5.1292830169
          ; bits_gained = 9.8707169831
          ; probability = 0.001068115234375
          ; next_best_guesses = Not_computed
          }
        ; { cue = { white = 3; black = 2 }
          ; size_remaining = 20
          ; bits_remaining = 4.3219280949
          ; bits_gained = 10.678071905100001
          ; probability = 0.0006103515625
          ; next_best_guesses = Not_computed
          }
        ; { cue = { white = 2; black = 3 }
          ; size_remaining = 10
          ; bits_remaining = 3.3219280949
          ; bits_gained = 11.6780719051
          ; probability = 0.00030517578125
          ; next_best_guesses = Not_computed
          }
        ; { cue = { white = 0; black = 5 }
          ; size_remaining = 1
          ; bits_remaining = 0
          ; bits_gained = 15
          ; probability = 3.0517578125E-05
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
    ; expected_bits_gained = 3.2383078370124765
    ; expected_bits_remaining = 11.761692162987524
    ; min_bits_gained = 2.2163878347000008
    ; max_bits_gained = 15
    ; max_bits_remaining = 12.7836121653
    ; by_cue =
        [ { cue = { white = 2; black = 0 }
          ; size_remaining = 7051
          ; bits_remaining = 12.7836121653
          ; bits_gained = 2.2163878347000008
          ; probability = 0.215179443359375
          ; next_best_guesses = Not_computed
          }
        ; { cue = { white = 1; black = 1 }
          ; size_remaining = 5432
          ; bits_remaining = 12.4072677642
          ; bits_gained = 2.5927322358
          ; probability = 0.165771484375
          ; next_best_guesses = Not_computed
          }
        ; { cue = { white = 1; black = 0 }
          ; size_remaining = 5196
          ; bits_remaining = 12.3431857154
          ; bits_gained = 2.6568142845999994
          ; probability = 0.1585693359375
          ; next_best_guesses = Not_computed
          }
        ; { cue = { white = 2; black = 1 }
          ; size_remaining = 3510
          ; bits_remaining = 11.7772553152
          ; bits_gained = 3.2227446848000003
          ; probability = 0.10711669921875
          ; next_best_guesses = Not_computed
          }
        ; { cue = { white = 3; black = 0 }
          ; size_remaining = 3095
          ; bits_remaining = 11.5957236941
          ; bits_gained = 3.4042763059
          ; probability = 0.094451904296875
          ; next_best_guesses = Not_computed
          }
        ; { cue = { white = 0; black = 1 }
          ; size_remaining = 2387
          ; bits_remaining = 11.2209828511
          ; bits_gained = 3.7790171488999995
          ; probability = 0.072845458984375
          ; next_best_guesses = Not_computed
          }
        ; { cue = { white = 0; black = 2 }
          ; size_remaining = 1523
          ; bits_remaining = 10.5727002265
          ; bits_gained = 4.4272997735
          ; probability = 0.046478271484375
          ; next_best_guesses = Not_computed
          }
        ; { cue = { white = 1; black = 2 }
          ; size_remaining = 1497
          ; bits_remaining = 10.5478585061
          ; bits_gained = 4.4521414938999992
          ; probability = 0.045684814453125
          ; next_best_guesses = Not_computed
          }
        ; { cue = { white = 0; black = 0 }
          ; size_remaining = 1024
          ; bits_remaining = 10
          ; bits_gained = 5
          ; probability = 0.03125
          ; next_best_guesses = Not_computed
          }
        ; { cue = { white = 3; black = 1 }
          ; size_remaining = 652
          ; bits_remaining = 9.3487281542
          ; bits_gained = 5.6512718458
          ; probability = 0.0198974609375
          ; next_best_guesses = Not_computed
          }
        ; { cue = { white = 4; black = 0 }
          ; size_remaining = 429
          ; bits_remaining = 8.7448338375
          ; bits_gained = 6.2551661625
          ; probability = 0.013092041015625
          ; next_best_guesses = Not_computed
          }
        ; { cue = { white = 2; black = 2 }
          ; size_remaining = 396
          ; bits_remaining = 8.6293566201
          ; bits_gained = 6.3706433799000006
          ; probability = 0.0120849609375
          ; next_best_guesses = Not_computed
          }
        ; { cue = { white = 0; black = 3 }
          ; size_remaining = 373
          ; bits_remaining = 8.5430318203
          ; bits_gained = 6.4569681797000005
          ; probability = 0.011383056640625
          ; next_best_guesses = Not_computed
          }
        ; { cue = { white = 1; black = 3 }
          ; size_remaining = 108
          ; bits_remaining = 6.7548875022
          ; bits_gained = 8.245112497800001
          ; probability = 0.0032958984375
          ; next_best_guesses = Not_computed
          }
        ; { cue = { white = 0; black = 4 }
          ; size_remaining = 35
          ; bits_remaining = 5.1292830169
          ; bits_gained = 9.8707169831
          ; probability = 0.001068115234375
          ; next_best_guesses = Not_computed
          }
        ; { cue = { white = 4; black = 1 }
          ; size_remaining = 24
          ; bits_remaining = 4.5849625007
          ; bits_gained = 10.4150374993
          ; probability = 0.000732421875
          ; next_best_guesses = Not_computed
          }
        ; { cue = { white = 3; black = 2 }
          ; size_remaining = 14
          ; bits_remaining = 3.8073549221
          ; bits_gained = 11.1926450779
          ; probability = 0.00042724609375
          ; next_best_guesses = Not_computed
          }
        ; { cue = { white = 5; black = 0 }
          ; size_remaining = 12
          ; bits_remaining = 3.5849625007
          ; bits_gained = 11.4150374993
          ; probability = 0.0003662109375
          ; next_best_guesses = Not_computed
          }
        ; { cue = { white = 2; black = 3 }
          ; size_remaining = 9
          ; bits_remaining = 3.1699250014
          ; bits_gained = 11.8300749986
          ; probability = 0.000274658203125
          ; next_best_guesses = Not_computed
          }
        ; { cue = { white = 0; black = 5 }
          ; size_remaining = 1
          ; bits_remaining = 0
          ; bits_gained = 15
          ; probability = 3.0517578125E-05
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
    ; expected_bits_gained = 3.0628695079213277
    ; expected_bits_remaining = 11.937130492078673
    ; min_bits_gained = 2.0414472846000002
    ; max_bits_gained = 15
    ; max_bits_remaining = 12.9585527154
    ; by_cue =
        [ { cue = { white = 1; black = 0 }
          ; size_remaining = 7960
          ; bits_remaining = 12.9585527154
          ; bits_gained = 2.0414472846000002
          ; probability = 0.242919921875
          ; next_best_guesses = Not_computed
          }
        ; { cue = { white = 1; black = 1 }
          ; size_remaining = 5436
          ; bits_remaining = 12.4083297408
          ; bits_gained = 2.5916702592000007
          ; probability = 0.1658935546875
          ; next_best_guesses = Not_computed
          }
        ; { cue = { white = 2; black = 0 }
          ; size_remaining = 4890
          ; bits_remaining = 12.2556187498
          ; bits_gained = 2.7443812502
          ; probability = 0.14923095703125
          ; next_best_guesses = Not_computed
          }
        ; { cue = { white = 0; black = 1 }
          ; size_remaining = 4467
          ; bits_remaining = 12.1250905393
          ; bits_gained = 2.8749094606999996
          ; probability = 0.136322021484375
          ; next_best_guesses = Not_computed
          }
        ; { cue = { white = 0; black = 0 }
          ; size_remaining = 3125
          ; bits_remaining = 11.6096404744
          ; bits_gained = 3.3903595255999992
          ; probability = 0.095367431640625
          ; next_best_guesses = Not_computed
          }
        ; { cue = { white = 0; black = 2 }
          ; size_remaining = 2014
          ; bits_remaining = 10.975847968
          ; bits_gained = 4.024152032
          ; probability = 0.06146240234375
          ; next_best_guesses = Not_computed
          }
        ; { cue = { white = 2; black = 1 }
          ; size_remaining = 1892
          ; bits_remaining = 10.8856963733
          ; bits_gained = 4.1143036267
          ; probability = 0.0577392578125
          ; next_best_guesses = Not_computed
          }
        ; { cue = { white = 1; black = 2 }
          ; size_remaining = 1179
          ; bits_remaining = 10.203348003
          ; bits_gained = 4.796651997
          ; probability = 0.035980224609375
          ; next_best_guesses = Not_computed
          }
        ; { cue = { white = 3; black = 0 }
          ; size_remaining = 796
          ; bits_remaining = 9.6366246205
          ; bits_gained = 5.3633753795000008
          ; probability = 0.0242919921875
          ; next_best_guesses = Not_computed
          }
        ; { cue = { white = 0; black = 3 }
          ; size_remaining = 399
          ; bits_remaining = 8.6402449362
          ; bits_gained = 6.3597550638
          ; probability = 0.012176513671875
          ; next_best_guesses = Not_computed
          }
        ; { cue = { white = 2; black = 2 }
          ; size_remaining = 231
          ; bits_remaining = 7.8517490414
          ; bits_gained = 7.1482509586
          ; probability = 0.007049560546875
          ; next_best_guesses = Not_computed
          }
        ; { cue = { white = 3; black = 1 }
          ; size_remaining = 204
          ; bits_remaining = 7.672425342
          ; bits_gained = 7.327574658
          ; probability = 0.0062255859375
          ; next_best_guesses = Not_computed
          }
        ; { cue = { white = 1; black = 3 }
          ; size_remaining = 84
          ; bits_remaining = 6.3923174228
          ; bits_gained = 8.6076825772
          ; probability = 0.0025634765625
          ; next_best_guesses = Not_computed
          }
        ; { cue = { white = 4; black = 0 }
          ; size_remaining = 36
          ; bits_remaining = 5.1699250014
          ; bits_gained = 9.8300749986
          ; probability = 0.0010986328125
          ; next_best_guesses = Not_computed
          }
        ; { cue = { white = 0; black = 4 }
          ; size_remaining = 35
          ; bits_remaining = 5.1292830169
          ; bits_gained = 9.8707169831
          ; probability = 0.001068115234375
          ; next_best_guesses = Not_computed
          }
        ; { cue = { white = 2; black = 3 }
          ; size_remaining = 7
          ; bits_remaining = 2.8073549221
          ; bits_gained = 12.1926450779
          ; probability = 0.000213623046875
          ; next_best_guesses = Not_computed
          }
        ; { cue = { white = 3; black = 2 }
          ; size_remaining = 6
          ; bits_remaining = 2.5849625007
          ; bits_gained = 12.4150374993
          ; probability = 0.00018310546875
          ; next_best_guesses = Not_computed
          }
        ; { cue = { white = 4; black = 1 }
          ; size_remaining = 6
          ; bits_remaining = 2.5849625007
          ; bits_gained = 12.4150374993
          ; probability = 0.00018310546875
          ; next_best_guesses = Not_computed
          }
        ; { cue = { white = 0; black = 5 }
          ; size_remaining = 1
          ; bits_remaining = 0
          ; bits_gained = 15
          ; probability = 3.0517578125E-05
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
    ; expected_bits_gained = 2.6420396142217317
    ; expected_bits_remaining = 12.357960385778268
    ; min_bits_gained = 2.047622748
    ; max_bits_gained = 15
    ; max_bits_remaining = 12.952377252
    ; by_cue =
        [ { cue = { white = 1; black = 0 }
          ; size_remaining = 7926
          ; bits_remaining = 12.952377252
          ; bits_gained = 2.047622748
          ; probability = 0.24188232421875
          ; next_best_guesses = Not_computed
          }
        ; { cue = { white = 0; black = 0 }
          ; size_remaining = 7776
          ; bits_remaining = 12.9248125036
          ; bits_gained = 2.0751874964
          ; probability = 0.2373046875
          ; next_best_guesses = Not_computed
          }
        ; { cue = { white = 0; black = 1 }
          ; size_remaining = 7585
          ; bits_remaining = 12.8889334651
          ; bits_gained = 2.1110665349000008
          ; probability = 0.231475830078125
          ; next_best_guesses = Not_computed
          }
        ; { cue = { white = 1; black = 1 }
          ; size_remaining = 3912
          ; bits_remaining = 11.933690655
          ; bits_gained = 3.0663093450000005
          ; probability = 0.119384765625
          ; next_best_guesses = Not_computed
          }
        ; { cue = { white = 0; black = 2 }
          ; size_remaining = 2668
          ; bits_remaining = 11.3815429512
          ; bits_gained = 3.6184570488
          ; probability = 0.0814208984375
          ; next_best_guesses = Not_computed
          }
        ; { cue = { white = 2; black = 0 }
          ; size_remaining = 1105
          ; bits_remaining = 10.1098306543
          ; bits_gained = 4.8901693457
          ; probability = 0.033721923828125
          ; next_best_guesses = Not_computed
          }
        ; { cue = { white = 1; black = 2 }
          ; size_remaining = 684
          ; bits_remaining = 9.4178525149
          ; bits_gained = 5.5821474851
          ; probability = 0.0208740234375
          ; next_best_guesses = Not_computed
          }
        ; { cue = { white = 2; black = 1 }
          ; size_remaining = 508
          ; bits_remaining = 8.9886846868
          ; bits_gained = 6.0113153132000008
          ; probability = 0.0155029296875
          ; next_best_guesses = Not_computed
          }
        ; { cue = { white = 0; black = 3 }
          ; size_remaining = 438
          ; bits_remaining = 8.7747870596
          ; bits_gained = 6.2252129404000005
          ; probability = 0.01336669921875
          ; next_best_guesses = Not_computed
          }
        ; { cue = { white = 2; black = 2 }
          ; size_remaining = 78
          ; bits_remaining = 6.2854022189
          ; bits_gained = 8.7145977811
          ; probability = 0.00238037109375
          ; next_best_guesses = Not_computed
          }
        ; { cue = { white = 1; black = 3 }
          ; size_remaining = 48
          ; bits_remaining = 5.5849625007
          ; bits_gained = 9.4150374993
          ; probability = 0.00146484375
          ; next_best_guesses = Not_computed
          }
        ; { cue = { white = 0; black = 4 }
          ; size_remaining = 35
          ; bits_remaining = 5.1292830169
          ; bits_gained = 9.8707169831
          ; probability = 0.001068115234375
          ; next_best_guesses = Not_computed
          }
        ; { cue = { white = 2; black = 3 }
          ; size_remaining = 4
          ; bits_remaining = 2
          ; bits_gained = 13
          ; probability = 0.0001220703125
          ; next_best_guesses = Not_computed
          }
        ; { cue = { white = 0; black = 5 }
          ; size_remaining = 1
          ; bits_remaining = 0
          ; bits_gained = 15
          ; probability = 3.0517578125E-05
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
    ; expected_bits_gained = 1.467273742044003
    ; expected_bits_remaining = 13.532726257955996
    ; min_bits_gained = 0.96322538969999982
    ; max_bits_gained = 15
    ; max_bits_remaining = 14.0367746103
    ; by_cue =
        [ { cue = { white = 0; black = 0 }
          ; size_remaining = 16807
          ; bits_remaining = 14.0367746103
          ; bits_gained = 0.96322538969999982
          ; probability = 0.512908935546875
          ; next_best_guesses = Not_computed
          }
        ; { cue = { white = 0; black = 1 }
          ; size_remaining = 12005
          ; bits_remaining = 13.5513477831
          ; bits_gained = 1.4486522168999993
          ; probability = 0.366363525390625
          ; next_best_guesses = Not_computed
          }
        ; { cue = { white = 0; black = 2 }
          ; size_remaining = 3430
          ; bits_remaining = 11.7439928611
          ; bits_gained = 3.2560071388999994
          ; probability = 0.10467529296875
          ; next_best_guesses = Not_computed
          }
        ; { cue = { white = 0; black = 3 }
          ; size_remaining = 490
          ; bits_remaining = 8.936637939
          ; bits_gained = 6.0633620609999994
          ; probability = 0.01495361328125
          ; next_best_guesses = Not_computed
          }
        ; { cue = { white = 0; black = 4 }
          ; size_remaining = 35
          ; bits_remaining = 5.1292830169
          ; bits_gained = 9.8707169831
          ; probability = 0.001068115234375
          ; next_best_guesses = Not_computed
          }
        ; { cue = { white = 0; black = 5 }
          ; size_remaining = 1
          ; bits_remaining = 0
          ; bits_gained = 15
          ; probability = 3.0517578125E-05
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
