open! Core
open Super_master_mind

let verify_steps (ts : Guess.t list) = ignore (ts : Guess.t list)

let%expect_test "" =
  verify_steps
    (Example.solve ~solution:(Code.create_exn [| Green; Blue; Orange; White; Red |]));
  [%expect
    {|
    (1
     ((candidate (Black Blue Brown Green Orange))
      (expected_bits_gained 3.2315534058614324)
      (expected_bits_remaining 11.768446594138567)
      (min_bits_gained 2.2125055003032372) (max_bits_gained 15)
      (max_bits_remaining 12.787494499696763)
      (by_cue
       (((cue ((white 2) (black 1))) (size_remaining 4680)
         (bits_remaining 12.192292814470767) (bits_gained 2.8077071855292335)
         (probability 0.142822265625) (next_best_guesses Not_computed))))))
    (2
     ((candidate (Red Blue Brown Black Black))
      (expected_bits_gained 3.2916088087635988)
      (expected_bits_remaining 8.9006840057071681)
      (min_bits_gained 2.337424431210529) (max_bits_gained 10.192292814470767)
      (max_bits_remaining 9.8548683832602375)
      (by_cue
       (((cue ((white 1) (black 1))) (size_remaining 804)
         (bits_remaining 9.65105169117893) (bits_gained 2.5412411232918366)
         (probability 0.1717948717948718) (next_best_guesses Not_computed))))))
    (3
     ((candidate (Green White Brown Blue Blue))
      (expected_bits_gained 3.6890883278111644)
      (expected_bits_remaining 5.9619633633677651)
      (min_bits_gained 2.7562339278709862) (max_bits_gained 9.65105169117893)
      (max_bits_remaining 6.8948177633079437)
      (by_cue
       (((cue ((white 2) (black 1))) (size_remaining 87)
         (bits_remaining 6.4429434958487288) (bits_gained 3.2081081953302011)
         (probability 0.10820895522388059) (next_best_guesses Not_computed))))))
    (4
     ((candidate (Blue Orange Brown Blue Yellow))
      (expected_bits_gained 3.7993220353970907)
      (expected_bits_remaining 2.6436214604516381)
      (min_bits_gained 2.9835118772114311) (max_bits_gained 6.4429434958487288)
      (max_bits_remaining 3.4594316186372978)
      (by_cue
       (((cue ((white 2) (black 0))) (size_remaining 11)
         (bits_remaining 3.4594316186372978) (bits_gained 2.9835118772114311)
         (probability 0.12643678160919541) (next_best_guesses Not_computed))))))
    (5
     ((candidate (Green Orange Red Orange Brown))
      (expected_bits_gained 3.2776134368191165)
      (expected_bits_remaining 0.18181818181818121)
      (min_bits_gained 2.4594316186372978) (max_bits_gained 3.4594316186372978)
      (max_bits_remaining 1)
      (by_cue
       (((cue ((white 2) (black 1))) (size_remaining 2) (bits_remaining 1)
         (bits_gained 2.4594316186372978) (probability 0.18181818181818182)
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
