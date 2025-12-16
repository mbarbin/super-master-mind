(*********************************************************************************)
(*  super-master-mind: A solver for the super master mind game                   *)
(*  SPDX-FileCopyrightText: 2021-2025 Mathieu Barbin <mathieu.barbin@gmail.com>  *)
(*  SPDX-License-Identifier: MIT                                                 *)
(*********************************************************************************)

(* This test shows the sequence of what would happen, assuming that each time we
   make a guess, we get back the cue that is the most likely - that is the one
   that gives back the least amount of information. *)

let%expect_test "min sequence" =
  let steps = Queue.create () in
  let add (t : Guess.t) =
    let by_cue =
      Nonempty_list.singleton
        { (Nonempty_list.hd t.by_cue) with next_best_guesses = Not_computed }
    in
    Queue.enqueue steps { t with by_cue }
  in
  let rec aux (t : Guess.t) ~task_pool ~possible_solutions =
    (* At each step, we choose to act as if we were in the case leading to the
       cue offering the least amount of information. *)
    add t;
    let by_cue = Nonempty_list.hd t.by_cue in
    let possible_solutions =
      Codes.filter possible_solutions ~candidate:t.candidate ~cue:by_cue.cue
    in
    if Codes.size possible_solutions = 1
    then (
      let solution = List.hd_exn (Codes.to_list possible_solutions) in
      add (Guess.compute ~possible_solutions ~candidate:solution))
    else (
      let guess =
        match by_cue.next_best_guesses with
        | Computed [] -> assert false
        | Computed (guess :: _) -> guess
        | Not_computed ->
          (match Guess.compute_k_best ~task_pool ~possible_solutions ~k:1 () with
           | [] -> assert false
           | guess :: _ -> guess)
      in
      aux guess ~task_pool ~possible_solutions)
  in
  let opening_book = Lazy.force Opening_book.opening_book in
  let root =
    Opening_book.root opening_book ~color_permutation:(force Color_permutation.identity)
  in
  Task_pool.with_t Task_pool.Config.default ~f:(fun ~task_pool ->
    aux root ~task_pool ~possible_solutions:Codes.all);
  let steps = Queue.to_list steps |> List.mapi ~f:(fun i e -> Int.succ i, e) in
  print_dyn (Dyn.record [ "number_of_steps", Dyn.int (List.length steps) ]);
  print_dyn (Dyn.list (fun (i, g) -> Dyn.Tuple [ Dyn.int i; Guess.to_dyn g ]) steps);
  [%expect
    {|
    { number_of_steps = 7 }
    [ (1,
       { candidate = [| Black;  Blue;  Brown;  Green;  Orange |]
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
           ]
       })
    ; (2,
       { candidate = [| Blue;  Black;  White;  Yellow;  Yellow |]
       ; expected_bits_gained = 3.40955621018
       ; expected_bits_remaining = 9.37793828951
       ; min_bits_gained = 2.44875811712
       ; max_bits_gained = 12.7874944997
       ; max_bits_remaining = 10.3387363826
       ; by_cue =
           [ { cue = { white = 2; black = 0 }
             ; size_remaining = 1295
             ; bits_remaining = 10.3387363826
             ; bits_gained = 2.44875811712
             ; probability = 0.183168316832
             ; next_best_guesses = Not_computed
             }
           ]
       })
    ; (3,
       { candidate = [| Orange;  White;  Blue;  Red;  Red |]
       ; expected_bits_gained = 3.64875869802
       ; expected_bits_remaining = 6.68997768456
       ; min_bits_gained = 2.71668456312
       ; max_bits_gained = 10.3387363826
       ; max_bits_remaining = 7.62205181946
       ; by_cue =
           [ { cue = { white = 1; black = 1 }
             ; size_remaining = 197
             ; bits_remaining = 7.62205181946
             ; bits_gained = 2.71668456312
             ; probability = 0.152123552124
             ; next_best_guesses = Not_computed
             }
           ]
       })
    ; (4,
       { candidate = [| White;  Green;  Black;  White;  Red |]
       ; expected_bits_gained = 3.7846616828
       ; expected_bits_remaining = 3.83739013666
       ; min_bits_gained = 2.86716431729
       ; max_bits_gained = 7.62205181946
       ; max_bits_remaining = 4.75488750216
       ; by_cue =
           [ { cue = { white = 1; black = 1 }
             ; size_remaining = 27
             ; bits_remaining = 4.75488750216
             ; bits_gained = 2.86716431729
             ; probability = 0.137055837563
             ; next_best_guesses = Not_computed
             }
           ]
       })
    ; (5,
       { candidate = [| Brown;  Red;  Yellow;  Orange;  Red |]
       ; expected_bits_gained = 3.66193287237
       ; expected_bits_remaining = 1.09295462979
       ; min_bits_gained = 2.75488750216
       ; max_bits_gained = 4.75488750216
       ; max_bits_remaining = 2.
       ; by_cue =
           [ { cue = { white = 1; black = 0 }
             ; size_remaining = 4
             ; bits_remaining = 2.
             ; bits_gained = 2.75488750216
             ; probability = 0.148148148148
             ; next_best_guesses = Not_computed
             }
           ]
       })
    ; (6,
       { candidate = [| Brown;  Brown;  Yellow;  White;  Yellow |]
       ; expected_bits_gained = 2.
       ; expected_bits_remaining = 0.
       ; min_bits_gained = 2.
       ; max_bits_gained = 2.
       ; max_bits_remaining = 0.
       ; by_cue =
           [ { cue = { white = 0; black = 1 }
             ; size_remaining = 1
             ; bits_remaining = 0.
             ; bits_gained = 2.
             ; probability = 0.25
             ; next_best_guesses = Not_computed
             }
           ]
       })
    ; (7,
       { candidate = [| Orange;  Orange;  Orange;  White;  Black |]
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
    ]
    |}]
;;
