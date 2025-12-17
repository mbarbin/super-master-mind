(*********************************************************************************)
(*  super-master-mind: A solver for the super master mind game                   *)
(*  SPDX-FileCopyrightText: 2021-2025 Mathieu Barbin <mathieu.barbin@gmail.com>  *)
(*  SPDX-License-Identifier: MIT                                                 *)
(*********************************************************************************)

let verify_steps (ts : Guess.t list) = ignore (ts : Guess.t list)
let with_task_pool ~f = Task_pool.with_t Task_pool.Config.default ~f

let%expect_test "1" =
  verify_steps
    (with_task_pool ~f:(fun ~task_pool ->
       Example.solve
         ~task_pool
         ~color_permutation:Color_permutation.identity
         ~solution:(Code.create_exn [| Green; Blue; Orange; White; Red |])));
  [%expect
    {|
    (1,
     { candidate = [| Black;  Blue;  Brown;  Green;  Orange |]
     ; expected_bits_gained = 3.2315534058559967
     ; expected_bits_remaining = 11.768446594144002
     ; min_bits_gained = 2.2125055003000007
     ; max_bits_gained = 15
     ; max_bits_remaining = 12.7874944997
     ; by_cue =
         [ { cue = { white = 2; black = 1 }
           ; size_remaining = 4680
           ; bits_remaining = 12.1922928145
           ; bits_gained = 2.8077071855
           ; probability = 0.142822265625
           ; next_best_guesses = Not_computed
           }
         ]
     })
    (2,
     { candidate = [| Black;  Blue;  Orange;  Orange;  Yellow |]
     ; expected_bits_gained = 3.2916088087752562
     ; expected_bits_remaining = 8.9006840057247434
     ; min_bits_gained = 2.3374244312000005
     ; max_bits_gained = 10.1922928145
     ; max_bits_remaining = 9.8548683833
     ; by_cue =
         [ { cue = { white = 0; black = 2 }
           ; size_remaining = 280
           ; bits_remaining = 8.1292830169
           ; bits_gained = 4.0630097975999995
           ; probability = 0.059829059829059832
           ; next_best_guesses = Not_computed
           }
         ]
     })
    (3,
     { candidate = [| Black;  Green;  Orange;  Red;  White |]
     ; expected_bits_gained = 3.7249049284260707
     ; expected_bits_remaining = 4.40437808847393
     ; min_bits_gained = 2.8073549220000009
     ; max_bits_gained = 8.1292830169
     ; max_bits_remaining = 5.3219280949
     ; by_cue =
         [ { cue = { white = 3; black = 1 }
           ; size_remaining = 19
           ; bits_remaining = 4.2479275134
           ; bits_gained = 3.8813555035000009
           ; probability = 0.067857142857142852
           ; next_best_guesses = Not_computed
           }
         ]
     })
    (4,
     { candidate = [| Black;  Black;  Red;  Orange;  Green |]
     ; expected_bits_gained = 3.2210972500210522
     ; expected_bits_remaining = 1.0268302633789474
     ; min_bits_gained = 2.6629650126999995
     ; max_bits_gained = 4.2479275134
     ; max_bits_remaining = 1.5849625007
     ; by_cue =
         [ { cue = { white = 3; black = 0 }
           ; size_remaining = 1
           ; bits_remaining = 0
           ; bits_gained = 4.2479275134
           ; probability = 0.052631578947368418
           ; next_best_guesses = Not_computed
           }
         ]
     })
    (5,
     { candidate = [| Green;  Blue;  Orange;  White;  Red |]
     ; expected_bits_gained = 0
     ; expected_bits_remaining = 0
     ; min_bits_gained = 0
     ; max_bits_gained = 0
     ; max_bits_remaining = 0
     ; by_cue =
         [ { cue = { white = 0; black = 5 }
           ; size_remaining = 1
           ; bits_remaining = 0
           ; bits_gained = 0
           ; probability = 1
           ; next_best_guesses = Not_computed
           }
         ]
     })
    |}]
;;

let%expect_test "2" =
  verify_steps
    (with_task_pool ~f:(fun ~task_pool ->
       Example.solve
         ~task_pool
         ~color_permutation:(lazy (Color_permutation.of_index_exn 40319))
         ~solution:(Code.create_exn [| Green; Blue; Orange; White; Red |])));
  [%expect
    {|
    (1,
     { candidate = [| Yellow;  White;  Red;  Orange;  Green |]
     ; expected_bits_gained = 3.2315534058559967
     ; expected_bits_remaining = 11.768446594144002
     ; min_bits_gained = 2.2125055003000007
     ; max_bits_gained = 15
     ; max_bits_remaining = 12.7874944997
     ; by_cue =
         [ { cue = { white = 4; black = 0 }
           ; size_remaining = 1215
           ; bits_remaining = 10.2467405985
           ; bits_gained = 4.7532594014999994
           ; probability = 0.037078857421875
           ; next_best_guesses = Not_computed
           }
         ]
     })
    (2,
     { candidate = [| White;  Yellow;  Green;  Green;  Black |]
     ; expected_bits_gained = 3.0838519192009879
     ; expected_bits_remaining = 7.1628886792990123
     ; min_bits_gained = 2.401250547600001
     ; max_bits_gained = 8.2467405985
     ; max_bits_remaining = 7.8454900509
     ; by_cue =
         [ { cue = { white = 2; black = 0 }
           ; size_remaining = 228
           ; bits_remaining = 7.8328900142
           ; bits_gained = 2.4138505843000004
           ; probability = 0.18765432098765433
           ; next_best_guesses = Not_computed
           }
         ]
     })
    (3,
     { candidate = [| Orange;  Blue;  Yellow;  Red;  White |]
     ; expected_bits_gained = 3.3377676472416669
     ; expected_bits_remaining = 4.4951223669583333
     ; min_bits_gained = 2.5109619193000006
     ; max_bits_gained = 7.8328900142
     ; max_bits_remaining = 5.3219280949
     ; by_cue =
         [ { cue = { white = 3; black = 1 }
           ; size_remaining = 40
           ; bits_remaining = 5.3219280949
           ; bits_gained = 2.5109619193000006
           ; probability = 0.17543859649122806
           ; next_best_guesses = Not_computed
           }
         ]
     })
    (4,
     { candidate = [| Orange;  Brown;  White;  Yellow;  Red |]
     ; expected_bits_gained = 3.587326145275
     ; expected_bits_remaining = 1.7346019496249996
     ; min_bits_gained = 2.7369655941999995
     ; max_bits_gained = 5.3219280949
     ; max_bits_remaining = 2.5849625007
     ; by_cue =
         [ { cue = { white = 2; black = 1 }
           ; size_remaining = 4
           ; bits_remaining = 2
           ; bits_gained = 3.3219280948999996
           ; probability = 0.1
           ; next_best_guesses = Not_computed
           }
         ]
     })
    (5,
     { candidate = [| Green;  Orange;  Yellow;  Yellow;  Yellow |]
     ; expected_bits_gained = 2
     ; expected_bits_remaining = 0
     ; min_bits_gained = 2
     ; max_bits_gained = 2
     ; max_bits_remaining = 0
     ; by_cue =
         [ { cue = { white = 1; black = 1 }
           ; size_remaining = 1
           ; bits_remaining = 0
           ; bits_gained = 2
           ; probability = 0.25
           ; next_best_guesses = Not_computed
           }
         ]
     })
    (6,
     { candidate = [| Green;  Blue;  Orange;  White;  Red |]
     ; expected_bits_gained = 0
     ; expected_bits_remaining = 0
     ; min_bits_gained = 0
     ; max_bits_gained = 0
     ; max_bits_remaining = 0
     ; by_cue =
         [ { cue = { white = 0; black = 5 }
           ; size_remaining = 1
           ; bits_remaining = 0
           ; bits_gained = 0
           ; probability = 1
           ; next_best_guesses = Not_computed
           }
         ]
     })
    |}]
;;
