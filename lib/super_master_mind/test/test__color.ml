let%expect_test "sexp_of_t" =
  print_s [%sexp (force Color.cardinality : int)];
  [%expect {| 8 |}];
  assert (force Color.cardinality = List.length (force Color.all));
  List.iter (force Color.all) ~f:(fun t -> print_s [%sexp (t : Color.t)]);
  [%expect
    {|
    Black
    Blue
    Brown
    Green
    Orange
    Red
    White
    Yellow |}]
;;

let%expect_test "indices" =
  List.iter (force Color.all) ~f:(fun color ->
    let index = Color.to_index color in
    let color' = Color.of_index_exn index in
    assert (Color.equal color color'));
  [%expect {||}];
  require_does_raise [%here] (fun () : Color.t ->
    Color.of_index_exn (force Color.cardinality));
  [%expect
    {|
    ("Index out of bounds" (
      (index       8)
      (cardinality 8))) |}];
  ()
;;

let%expect_test "hum" =
  List.iter Color.Hum.all ~f:(fun hum ->
    let color = Color.of_hum hum in
    let hum' = Color.to_hum color in
    assert (Color.Hum.equal hum hum'));
  [%expect {||}]
;;
