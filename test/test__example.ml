open! Core
open Super_master_mind

let verify_steps (ts : Guess.t list) = ignore (ts : Guess.t list)

let%expect_test "1" =
  verify_steps
    (Example.solve
       ~color_permutation:Color_permutation.identity
       ~solution:(Code.create_exn [| Green; Blue; Orange; White; Red |]));
  [%expect
    {|
    (1
     ((candidate (Black Blue Brown Green Orange))
      (expected_bits_gained 3.2315534058614328)
      (expected_bits_remaining 11.768446594138567)
      (min_bits_gained 2.212505500303239) (max_bits_gained 15)
      (max_bits_remaining 12.787494499696761)
      (by_cue
       (((cue ((white 2) (black 1))) (size_remaining 4680)
         (bits_remaining 12.192292814470767) (bits_gained 2.8077071855292335)
         (probability 0.142822265625) (next_best_guesses Not_computed))))))
    (2
     ((candidate (Red Blue Brown Black Black))
      (expected_bits_gained 3.2916088087636)
      (expected_bits_remaining 8.9006840057071663)
      (min_bits_gained 2.3374244312105308) (max_bits_gained 10.192292814470767)
      (max_bits_remaining 9.8548683832602357)
      (by_cue
       (((cue ((white 1) (black 1))) (size_remaining 804)
         (bits_remaining 9.6510516911789281) (bits_gained 2.5412411232918384)
         (probability 0.1717948717948718) (next_best_guesses Not_computed))))))
    (3
     ((candidate (Green White Brown Blue Blue))
      (expected_bits_gained 3.6890883278111639)
      (expected_bits_remaining 5.9619633633677642)
      (min_bits_gained 2.7562339278709844) (max_bits_gained 9.6510516911789281)
      (max_bits_remaining 6.8948177633079437)
      (by_cue
       (((cue ((white 2) (black 1))) (size_remaining 87)
         (bits_remaining 6.4429434958487279) (bits_gained 3.2081081953302)
         (probability 0.10820895522388059) (next_best_guesses Not_computed))))))
    (4
     ((candidate (Blue Orange Brown Blue Yellow))
      (expected_bits_gained 3.7993220353970902)
      (expected_bits_remaining 2.6436214604516377)
      (min_bits_gained 2.9835118772114306) (max_bits_gained 6.4429434958487279)
      (max_bits_remaining 3.4594316186372973)
      (by_cue
       (((cue ((white 2) (black 0))) (size_remaining 11)
         (bits_remaining 3.4594316186372973) (bits_gained 2.9835118772114306)
         (probability 0.12643678160919541) (next_best_guesses Not_computed))))))
    (5
     ((candidate (Green Orange Red Orange Brown))
      (expected_bits_gained 3.2776134368191165)
      (expected_bits_remaining 0.18181818181818077)
      (min_bits_gained 2.4594316186372973) (max_bits_gained 3.4594316186372973)
      (max_bits_remaining 1)
      (by_cue
       (((cue ((white 2) (black 1))) (size_remaining 2) (bits_remaining 1)
         (bits_gained 2.4594316186372973) (probability 0.18181818181818182)
         (next_best_guesses Not_computed))))))
    (6
     ((candidate (Black Black Black Red Black)) (expected_bits_gained 1)
      (expected_bits_remaining 0) (min_bits_gained 1) (max_bits_gained 1)
      (max_bits_remaining 0)
      (by_cue
       (((cue ((white 1) (black 0))) (size_remaining 1) (bits_remaining 0)
         (bits_gained 1) (probability 0.5) (next_best_guesses Not_computed))))))
    (7
     ((candidate (Green Blue Orange White Red)) (expected_bits_gained 0)
      (expected_bits_remaining 0) (min_bits_gained 0) (max_bits_gained 0)
      (max_bits_remaining 0)
      (by_cue
       (((cue ((white 0) (black 5))) (size_remaining 1) (bits_remaining 0)
         (bits_gained 0) (probability 1) (next_best_guesses Not_computed)))))) |}]
;;

let%expect_test "2" =
  verify_steps
    (Example.solve
       ~color_permutation:(Color_permutation.of_index_exn 40319)
       ~solution:(Code.create_exn [| Green; Blue; Orange; White; Red |]));
  [%expect
    {|
    (1
     ((candidate (Yellow White Red Orange Green))
      (expected_bits_gained 3.2315534058614328)
      (expected_bits_remaining 11.768446594138567)
      (min_bits_gained 2.212505500303239) (max_bits_gained 15)
      (max_bits_remaining 12.787494499696761)
      (by_cue
       (((cue ((white 4) (black 0))) (size_remaining 1215)
         (bits_remaining 10.246740598493144) (bits_gained 4.7532594015068561)
         (probability 0.037078857421875) (next_best_guesses Not_computed))))))
    (2
     ((candidate (Brown Red White Yellow Yellow))
      (expected_bits_gained 3.0838519191797964)
      (expected_bits_remaining 7.1628886793133475)
      (min_bits_gained 2.4012505475487691) (max_bits_gained 8.2467405984931439)
      (max_bits_remaining 7.8454900509443748)
      (by_cue
       (((cue ((white 2) (black 0))) (size_remaining 228)
         (bits_remaining 7.8328900141647413) (bits_gained 2.4138505843284026)
         (probability 0.18765432098765433) (next_best_guesses Not_computed))))))
    (3
     ((candidate (Red Blue Orange Green White))
      (expected_bits_gained 3.3377676472031377)
      (expected_bits_remaining 4.4951223669616036)
      (min_bits_gained 2.5109619192773787) (max_bits_gained 7.8328900141647413)
      (max_bits_remaining 5.3219280948873626)
      (by_cue
       (((cue ((white 3) (black 2))) (size_remaining 6)
         (bits_remaining 2.5849625007211561) (bits_gained 5.2479275134435852)
         (probability 0.026315789473684209) (next_best_guesses Not_computed))))))
    (4
     ((candidate (Green Blue Orange White Blue))
      (expected_bits_gained 2.2516291673878226)
      (expected_bits_remaining 0.33333333333333348)
      (min_bits_gained 1.5849625007211561) (max_bits_gained 2.5849625007211561)
      (max_bits_remaining 1)
      (by_cue
       (((cue ((white 0) (black 4))) (size_remaining 1) (bits_remaining 0)
         (bits_gained 2.5849625007211561) (probability 0.16666666666666666)
         (next_best_guesses Not_computed))))))
    (5
     ((candidate (Green Blue Orange White Red)) (expected_bits_gained 0)
      (expected_bits_remaining 0) (min_bits_gained 0) (max_bits_gained 0)
      (max_bits_remaining 0)
      (by_cue
       (((cue ((white 0) (black 5))) (size_remaining 1) (bits_remaining 0)
         (bits_gained 0) (probability 1) (next_best_guesses Not_computed)))))) |}]
;;
