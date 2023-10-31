open Super_master_mind

let%expect_test "depth" =
  let opening_book = Lazy.force Opening_book.opening_book in
  let depth = Opening_book.depth opening_book in
  print_s [%sexp { depth : int }];
  [%expect {| ((depth 2)) |}]
;;

let%expect_test "opening-book validity" =
  let opening_book = Lazy.force Opening_book.opening_book in
  let test ~color_permutation =
    require_does_not_raise [%here] (fun () ->
      let t = Opening_book.root opening_book ~color_permutation in
      Guess.verify t ~possible_solutions:Codes.all
      |> Result.map_error ~f:Guess.Verify_error.to_error
      |> Or_error.ok_exn)
  in
  test ~color_permutation:(force Color_permutation.identity);
  [%expect {| |}];
  test ~color_permutation:(Color_permutation.of_index_exn 100);
  [%expect {| |}];
  test ~color_permutation:(Color_permutation.of_index_exn 1_000);
  [%expect {| |}];
  test ~color_permutation:(Color_permutation.of_index_exn 40_000);
  [%expect {| |}];
  ()
;;
