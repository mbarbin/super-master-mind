open! Core
open Super_master_mind

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
     ((candidate (Black Blue Orange Orange Yellow))
      (expected_bits_gained 3.2916088087636)
      (expected_bits_remaining 8.9006840057071663)
      (min_bits_gained 2.3374244312105308) (max_bits_gained 10.192292814470767)
      (max_bits_remaining 9.8548683832602357)
      (by_cue
       (((cue ((white 0) (black 2))) (size_remaining 280)
         (bits_remaining 8.1292830169449672) (bits_gained 4.0630097975257993)
         (probability 0.059829059829059832) (next_best_guesses Not_computed))))))
    (3
     ((candidate (Black Green Orange Red White))
      (expected_bits_gained 3.7249049284531512)
      (expected_bits_remaining 4.404378088491816)
      (min_bits_gained 2.8073549220576046) (max_bits_gained 8.1292830169449672)
      (max_bits_remaining 5.3219280948873626)
      (by_cue
       (((cue ((white 3) (black 1))) (size_remaining 19)
         (bits_remaining 4.2479275134435852) (bits_gained 3.881355503501382)
         (probability 0.067857142857142852) (next_best_guesses Not_computed))))))
    (4
     ((candidate (Black Black Red Orange Green))
      (expected_bits_gained 3.2210972500579564)
      (expected_bits_remaining 1.0268302633856288)
      (min_bits_gained 2.6629650127224291) (max_bits_gained 4.2479275134435852)
      (max_bits_remaining 1.5849625007211561)
      (by_cue
       (((cue ((white 3) (black 0))) (size_remaining 1) (bits_remaining 0)
         (bits_gained 4.2479275134435852) (probability 0.052631578947368418)
         (next_best_guesses Not_computed))))))
    (5
     ((candidate (Green Blue Orange White Red)) (expected_bits_gained 0)
      (expected_bits_remaining 0) (min_bits_gained 0) (max_bits_gained 0)
      (max_bits_remaining 0)
      (by_cue
       (((cue ((white 0) (black 5))) (size_remaining 1) (bits_remaining 0)
         (bits_gained 0) (probability 1) (next_best_guesses Not_computed)))))) |}]
;;

let%expect_test "2" =
  verify_steps
    (with_task_pool ~f:(fun ~task_pool ->
       Example.solve
         ~task_pool
         ~color_permutation:(Color_permutation.of_index_exn 40319)
         ~solution:(Code.create_exn [| Green; Blue; Orange; White; Red |])));
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
     ((candidate (White Yellow Green Green Black))
      (expected_bits_gained 3.0838519191797964)
      (expected_bits_remaining 7.1628886793133475)
      (min_bits_gained 2.4012505475487691) (max_bits_gained 8.2467405984931439)
      (max_bits_remaining 7.8454900509443748)
      (by_cue
       (((cue ((white 2) (black 0))) (size_remaining 228)
         (bits_remaining 7.8328900141647413) (bits_gained 2.4138505843284026)
         (probability 0.18765432098765433) (next_best_guesses Not_computed))))))
    (3
     ((candidate (Orange Blue Yellow Red White))
      (expected_bits_gained 3.3377676472031377)
      (expected_bits_remaining 4.4951223669616036)
      (min_bits_gained 2.5109619192773787) (max_bits_gained 7.8328900141647413)
      (max_bits_remaining 5.3219280948873626)
      (by_cue
       (((cue ((white 3) (black 1))) (size_remaining 40)
         (bits_remaining 5.3219280948873626) (bits_gained 2.5109619192773787)
         (probability 0.17543859649122806) (next_best_guesses Not_computed))))))
    (4
     ((candidate (Orange Brown White Yellow Red))
      (expected_bits_gained 3.5873261452560086)
      (expected_bits_remaining 1.7346019496313541)
      (min_bits_gained 2.7369655941662066) (max_bits_gained 5.3219280948873626)
      (max_bits_remaining 2.5849625007211561)
      (by_cue
       (((cue ((white 2) (black 1))) (size_remaining 4) (bits_remaining 2)
         (bits_gained 3.3219280948873626) (probability 0.1)
         (next_best_guesses Not_computed))))))
    (5
     ((candidate (Green Orange Yellow Yellow Yellow)) (expected_bits_gained 2)
      (expected_bits_remaining 0) (min_bits_gained 2) (max_bits_gained 2)
      (max_bits_remaining 0)
      (by_cue
       (((cue ((white 1) (black 1))) (size_remaining 1) (bits_remaining 0)
         (bits_gained 2) (probability 0.25) (next_best_guesses Not_computed))))))
    (6
     ((candidate (Green Blue Orange White Red)) (expected_bits_gained 0)
      (expected_bits_remaining 0) (min_bits_gained 0) (max_bits_gained 0)
      (max_bits_remaining 0)
      (by_cue
       (((cue ((white 0) (black 5))) (size_remaining 1) (bits_remaining 0)
         (bits_gained 0) (probability 1) (next_best_guesses Not_computed)))))) |}]
;;
