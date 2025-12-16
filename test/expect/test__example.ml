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
     ; expected_bits_gained = 3.23155340586
     ; expected_bits_remaining = 11.7684465941
     ; min_bits_gained = 2.2125055003
     ; max_bits_gained = 15.
     ; max_bits_remaining = 12.7874944997
     ; by_cue =
         [ { cue = { white = 2; black = 1 }
           ; size_remaining = 4680
           ; bits_remaining = 12.1922928145
           ; bits_gained = 2.80770718553
           ; probability = 0.142822265625
           ; next_best_guesses = Not_computed
           }
         ]
     })
    (2,
     { candidate = [| Black;  Blue;  Orange;  Orange;  Yellow |]
     ; expected_bits_gained = 3.29160880876
     ; expected_bits_remaining = 8.90068400571
     ; min_bits_gained = 2.33742443121
     ; max_bits_gained = 10.1922928145
     ; max_bits_remaining = 9.85486838326
     ; by_cue =
         [ { cue = { white = 0; black = 2 }
           ; size_remaining = 280
           ; bits_remaining = 8.12928301694
           ; bits_gained = 4.06300979753
           ; probability = 0.0598290598291
           ; next_best_guesses = Not_computed
           }
         ]
     })
    (3,
     { candidate = [| Black;  Green;  Orange;  Red;  White |]
     ; expected_bits_gained = 3.72490492845
     ; expected_bits_remaining = 4.40437808849
     ; min_bits_gained = 2.80735492206
     ; max_bits_gained = 8.12928301694
     ; max_bits_remaining = 5.32192809489
     ; by_cue =
         [ { cue = { white = 3; black = 1 }
           ; size_remaining = 19
           ; bits_remaining = 4.24792751344
           ; bits_gained = 3.8813555035
           ; probability = 0.0678571428571
           ; next_best_guesses = Not_computed
           }
         ]
     })
    (4,
     { candidate = [| Black;  Black;  Red;  Orange;  Green |]
     ; expected_bits_gained = 3.22109725006
     ; expected_bits_remaining = 1.02683026339
     ; min_bits_gained = 2.66296501272
     ; max_bits_gained = 4.24792751344
     ; max_bits_remaining = 1.58496250072
     ; by_cue =
         [ { cue = { white = 3; black = 0 }
           ; size_remaining = 1
           ; bits_remaining = 0.
           ; bits_gained = 4.24792751344
           ; probability = 0.0526315789474
           ; next_best_guesses = Not_computed
           }
         ]
     })
    (5,
     { candidate = [| Green;  Blue;  Orange;  White;  Red |]
     ; expected_bits_gained = 0.
     ; expected_bits_remaining = 0.
     ; min_bits_gained = 0.
     ; max_bits_gained = 0.
     ; max_bits_remaining = 0.
     ; by_cue =
         [ { cue = { white = 0; black = 5 }
           ; size_remaining = 1
           ; bits_remaining = 0.
           ; bits_gained = 0.
           ; probability = 1.
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
     ; expected_bits_gained = 3.23155340586
     ; expected_bits_remaining = 11.7684465941
     ; min_bits_gained = 2.2125055003
     ; max_bits_gained = 15.
     ; max_bits_remaining = 12.7874944997
     ; by_cue =
         [ { cue = { white = 4; black = 0 }
           ; size_remaining = 1215
           ; bits_remaining = 10.2467405985
           ; bits_gained = 4.75325940151
           ; probability = 0.0370788574219
           ; next_best_guesses = Not_computed
           }
         ]
     })
    (2,
     { candidate = [| White;  Yellow;  Green;  Green;  Black |]
     ; expected_bits_gained = 3.08385191918
     ; expected_bits_remaining = 7.16288867931
     ; min_bits_gained = 2.40125054755
     ; max_bits_gained = 8.24674059849
     ; max_bits_remaining = 7.84549005094
     ; by_cue =
         [ { cue = { white = 2; black = 0 }
           ; size_remaining = 228
           ; bits_remaining = 7.83289001416
           ; bits_gained = 2.41385058433
           ; probability = 0.187654320988
           ; next_best_guesses = Not_computed
           }
         ]
     })
    (3,
     { candidate = [| Orange;  Blue;  Yellow;  Red;  White |]
     ; expected_bits_gained = 3.3377676472
     ; expected_bits_remaining = 4.49512236696
     ; min_bits_gained = 2.51096191928
     ; max_bits_gained = 7.83289001416
     ; max_bits_remaining = 5.32192809489
     ; by_cue =
         [ { cue = { white = 3; black = 1 }
           ; size_remaining = 40
           ; bits_remaining = 5.32192809489
           ; bits_gained = 2.51096191928
           ; probability = 0.175438596491
           ; next_best_guesses = Not_computed
           }
         ]
     })
    (4,
     { candidate = [| Orange;  Brown;  White;  Yellow;  Red |]
     ; expected_bits_gained = 3.58732614526
     ; expected_bits_remaining = 1.73460194963
     ; min_bits_gained = 2.73696559417
     ; max_bits_gained = 5.32192809489
     ; max_bits_remaining = 2.58496250072
     ; by_cue =
         [ { cue = { white = 2; black = 1 }
           ; size_remaining = 4
           ; bits_remaining = 2.
           ; bits_gained = 3.32192809489
           ; probability = 0.1
           ; next_best_guesses = Not_computed
           }
         ]
     })
    (5,
     { candidate = [| Green;  Orange;  Yellow;  Yellow;  Yellow |]
     ; expected_bits_gained = 2.
     ; expected_bits_remaining = 0.
     ; min_bits_gained = 2.
     ; max_bits_gained = 2.
     ; max_bits_remaining = 0.
     ; by_cue =
         [ { cue = { white = 1; black = 1 }
           ; size_remaining = 1
           ; bits_remaining = 0.
           ; bits_gained = 2.
           ; probability = 0.25
           ; next_best_guesses = Not_computed
           }
         ]
     })
    (6,
     { candidate = [| Green;  Blue;  Orange;  White;  Red |]
     ; expected_bits_gained = 0.
     ; expected_bits_remaining = 0.
     ; min_bits_gained = 0.
     ; max_bits_gained = 0.
     ; max_bits_remaining = 0.
     ; by_cue =
         [ { cue = { white = 0; black = 5 }
           ; size_remaining = 1
           ; bits_remaining = 0.
           ; bits_gained = 0.
           ; probability = 1.
           ; next_best_guesses = Not_computed
           }
         ]
     })
    |}]
;;
