open! Core
open Super_master_mind

let%expect_test "min sequence" =
  let opening_book = Lazy.force Opening_book.opening_book in
  let root = Opening_book.root opening_book in
  let rec aux (t : Guess.t) ~possible_solutions =
    (* At each step, we choose to act as if we were in the case
       leading to the cue offering the least information. *)
    if Array.length t.by_cue = 0
    then ()
    else (
      let by_cue = t.by_cue.(0) in
      t.by_cue <- [| by_cue |];
      let possible_solutions =
        Permutations.filter possible_solutions ~candidate:t.candidate ~cue:by_cue.cue
      in
      match by_cue.next_best_guesses with
      | Computed [] -> ()
      | Computed (guess :: _) -> aux guess ~possible_solutions
      | Not_computed ->
        let next_best_guesses =
          match Guess.compute_k_best ~possible_solutions ~k:1 with
          | [] -> []
          | guess :: _ ->
            aux guess ~possible_solutions;
            [ guess ]
        in
        by_cue.next_best_guesses <- Computed next_best_guesses)
  in
  aux root ~possible_solutions:Permutations.all;
  print_s [%sexp (root : Guess.t)];
  [%expect
    {|
    ((candidate (Black Blue Brown Green Orange))
     (expected_bits_gained 3.2315534058614324)
     (expected_bits_remaining 11.768446594138567)
     (min_bits_gained 2.2125055003032372) (max_bits_gained 15)
     (max_bits_remaining 12.787494499696763)
     (by_cue
      (((cue ((white 2) (black 0))) (size_remaining 7070)
        (bits_remaining 12.787494499696763) (bits_gained 2.2125055003032372)
        (probability 0.21575927734375)
        (next_best_guesses
         (Computed
          (((candidate (Orange White Red Red Black))
            (expected_bits_gained 3.409556210184622)
            (expected_bits_remaining 9.37793828951214)
            (min_bits_gained 2.4487581171228463)
            (max_bits_gained 12.787494499696763)
            (max_bits_remaining 10.338736382573916)
            (by_cue
             (((cue ((white 2) (black 0))) (size_remaining 1295)
               (bits_remaining 10.338736382573916)
               (bits_gained 2.4487581171228463) (probability 0.18316831683168316)
               (next_best_guesses
                (Computed
                 (((candidate (White Black Yellow Yellow Brown))
                   (expected_bits_gained 3.6487586980150937)
                   (expected_bits_remaining 6.6899776845588228)
                   (min_bits_gained 2.71668456311754)
                   (max_bits_gained 10.338736382573916)
                   (max_bits_remaining 7.6220518194563764)
                   (by_cue
                    (((cue ((white 1) (black 1))) (size_remaining 197)
                      (bits_remaining 7.6220518194563764)
                      (bits_gained 2.71668456311754)
                      (probability 0.15212355212355214)
                      (next_best_guesses
                       (Computed
                        (((candidate (Green Orange Yellow White White))
                          (expected_bits_gained 3.7846616827968043)
                          (expected_bits_remaining 3.8373901366595722)
                          (min_bits_gained 2.8671643172929073)
                          (max_bits_gained 7.6220518194563764)
                          (max_bits_remaining 4.7548875021634691)
                          (by_cue
                           (((cue ((white 1) (black 1))) (size_remaining 27)
                             (bits_remaining 4.7548875021634691)
                             (bits_gained 2.8671643172929073)
                             (probability 0.13705583756345177)
                             (next_best_guesses
                              (Computed
                               (((candidate (Yellow Red Yellow Brown Blue))
                                 (expected_bits_gained 3.6619328723735833)
                                 (expected_bits_remaining 1.0929546297898858)
                                 (min_bits_gained 2.7548875021634691)
                                 (max_bits_gained 4.7548875021634691)
                                 (max_bits_remaining 2)
                                 (by_cue
                                  (((cue ((white 1) (black 0)))
                                    (size_remaining 4) (bits_remaining 2)
                                    (bits_gained 2.7548875021634691)
                                    (probability 0.14814814814814814)
                                    (next_best_guesses
                                     (Computed
                                      (((candidate
                                         (Blue Brown Black Black Black))
                                        (expected_bits_gained 2)
                                        (expected_bits_remaining 0)
                                        (min_bits_gained 2) (max_bits_gained 2)
                                        (max_bits_remaining 0)
                                        (by_cue
                                         (((cue ((white 0) (black 1)))
                                           (size_remaining 1) (bits_remaining 0)
                                           (bits_gained 2) (probability 0.25)
                                           (next_best_guesses (Computed ()))))))))))))))))))))))))))))))))))))))))) |}]
;;
