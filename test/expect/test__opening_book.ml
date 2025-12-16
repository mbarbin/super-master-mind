(*********************************************************************************)
(*  super-master-mind: A solver for the super master mind game                   *)
(*  SPDX-FileCopyrightText: 2021-2025 Mathieu Barbin <mathieu.barbin@gmail.com>  *)
(*  SPDX-License-Identifier: MIT                                                 *)
(*********************************************************************************)

let%expect_test "depth" =
  let opening_book = Lazy.force Opening_book.opening_book in
  let depth = Opening_book.depth opening_book in
  print_dyn (Dyn.record [ "depth", Dyn.int depth ]);
  [%expect {| { depth = 2 } |}]
;;

let%expect_test "opening-book validity" =
  let opening_book = Lazy.force Opening_book.opening_book in
  let test ~color_permutation =
    let t = Opening_book.root opening_book ~color_permutation in
    match Guess.verify t ~possible_solutions:Codes.all with
    | Ok () -> ()
    | Error err ->
      (Guess.Verify_error.print_hum err Out_channel.stdout;
       print_endline "Opening book check failed.")
      [@coverage off]
  in
  test ~color_permutation:(Lazy.force Color_permutation.identity);
  [%expect
    {|
    Unexpected values:
    -1,9 +1,9
      { candidate = [| Black;  Blue;  Brown;  Green;  Orange |]
    -|; expected_bits_gained = 3.2315534058559967
    +|; expected_bits_gained = 3.2315534058614328
    -|; expected_bits_remaining = 11.768446594144002
    +|; expected_bits_remaining = 11.768446594138567
    -|; min_bits_gained = 2.2125055003000007
    +|; min_bits_gained = 2.212505500303239
      ; max_bits_gained = 15
    -|; max_bits_remaining = 12.7874944997
    +|; max_bits_remaining = 12.787494499696761
      ; by_cue =
          [ { cue = { white = 2; black = 0 }
            ; size_remaining = 7070
    Opening book check failed.
    |}];
  test ~color_permutation:(Color_permutation.of_index_exn 100);
  [%expect
    {|
    Unexpected values:
    -1,9 +1,9
      { candidate = [| Black;  Blue;  Brown;  Yellow;  Green |]
    -|; expected_bits_gained = 3.2315534058559967
    +|; expected_bits_gained = 3.2315534058614328
    -|; expected_bits_remaining = 11.768446594144002
    +|; expected_bits_remaining = 11.768446594138567
    -|; min_bits_gained = 2.2125055003000007
    +|; min_bits_gained = 2.212505500303239
      ; max_bits_gained = 15
    -|; max_bits_remaining = 12.7874944997
    +|; max_bits_remaining = 12.787494499696761
      ; by_cue =
          [ { cue = { white = 2; black = 0 }
            ; size_remaining = 7070
    Opening book check failed.
    |}];
  test ~color_permutation:(Color_permutation.of_index_exn 1_000);
  [%expect
    {|
    Unexpected values:
    -1,9 +1,9
      { candidate = [| Black;  Brown;  Orange;  Green;  White |]
    -|; expected_bits_gained = 3.2315534058559967
    +|; expected_bits_gained = 3.2315534058614328
    -|; expected_bits_remaining = 11.768446594144002
    +|; expected_bits_remaining = 11.768446594138567
    -|; min_bits_gained = 2.2125055003000007
    +|; min_bits_gained = 2.212505500303239
      ; max_bits_gained = 15
    -|; max_bits_remaining = 12.7874944997
    +|; max_bits_remaining = 12.787494499696761
      ; by_cue =
          [ { cue = { white = 2; black = 0 }
            ; size_remaining = 7070
    Opening book check failed.
    |}];
  test ~color_permutation:(Color_permutation.of_index_exn 40_000);
  [%expect
    {|
    Unexpected values:
    -1,9 +1,9
      { candidate = [| Yellow;  White;  Green;  Blue;  Orange |]
    -|; expected_bits_gained = 3.2315534058559967
    +|; expected_bits_gained = 3.2315534058614328
    -|; expected_bits_remaining = 11.768446594144002
    +|; expected_bits_remaining = 11.768446594138567
    -|; min_bits_gained = 2.2125055003000007
    +|; min_bits_gained = 2.212505500303239
      ; max_bits_gained = 15
    -|; max_bits_remaining = 12.7874944997
    +|; max_bits_remaining = 12.787494499696761
      ; by_cue =
          [ { cue = { white = 2; black = 0 }
            ; size_remaining = 7070
    Opening book check failed.
    |}];
  ()
;;
