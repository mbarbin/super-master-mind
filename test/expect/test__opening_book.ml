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
  [%expect {||}];
  test ~color_permutation:(Color_permutation.of_index_exn 100);
  [%expect {||}];
  test ~color_permutation:(Color_permutation.of_index_exn 1_000);
  [%expect {||}];
  test ~color_permutation:(Color_permutation.of_index_exn 40_000);
  [%expect {||}];
  ()
;;
