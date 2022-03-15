open! Core
open Super_master_mind

let%expect_test "opening-book validity" =
  let opening_book = Lazy.force Opening_book.opening_book in
  let test ~color_permutation =
    let t = Opening_book.root opening_book ~color_permutation in
    let result =
      if Guess.verify t ~possible_solutions:Codes.all then Ok () else Error ()
    in
    print_s [%sexp (result : (unit, unit) Result.t)]
  in
  test ~color_permutation:Color_permutation.identity;
  [%expect {| (Ok ()) |}];
  test ~color_permutation:(Color_permutation.of_index_exn 100);
  [%expect {| (Ok ()) |}];
  test ~color_permutation:(Color_permutation.of_index_exn 1_000);
  [%expect {| (Ok ()) |}];
  test ~color_permutation:(Color_permutation.of_index_exn 40_000);
  [%expect {| (Ok ()) |}];
  ()
;;
