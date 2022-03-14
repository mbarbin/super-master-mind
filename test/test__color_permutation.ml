open! Core
open Super_master_mind

let%expect_test "bounds" =
  let zero =
    Array.init Color.cardinality ~f:(fun i -> i |> Color.of_index_exn |> Color.to_hum)
    |> Color_permutation.create_exn
  in
  let max =
    Array.init Color.cardinality ~f:(fun i ->
        Color.of_index_exn (Color.cardinality - 1 - i) |> Color.to_hum)
    |> Color_permutation.create_exn
  in
  let test i expected =
    let t = Color_permutation.of_index_exn i in
    if Color_permutation.equal t expected
    then print_s [%sexp (i : int), (t : Color_permutation.t)]
    else
      raise_s
        [%sexp
          "Unexpected value"
          , { i : int; expected : Color_permutation.t; got = (t : Color_permutation.t) }]
  in
  test 0 zero;
  [%expect {| (0 (Black Blue Brown Green Orange Red White Yellow)) |}];
  test (Color_permutation.cardinality - 1) max;
  [%expect {| (40319 (Yellow White Red Orange Green Brown Blue Black)) |}]
;;

let%expect_test "sexp_of" =
  let print i =
    print_s [%sexp (i : int), (Color_permutation.of_index_exn i : Color_permutation.t)]
  in
  print 0;
  [%expect {| (0 (Black Blue Brown Green Orange Red White Yellow)) |}];
  print 1;
  [%expect {| (1 (Black Blue Brown Green Orange Red Yellow White)) |}];
  print 2;
  [%expect {| (2 (Black Blue Brown Green Orange White Red Yellow)) |}];
  print 3;
  [%expect {| (3 (Black Blue Brown Green Orange White Yellow Red)) |}];
  print 4;
  [%expect {| (4 (Black Blue Brown Green Orange Yellow Red White)) |}];
  print 40319;
  [%expect {| (40319 (Yellow White Red Orange Green Brown Blue Black)) |}];
  print 40318;
  [%expect {| (40318 (Yellow White Red Orange Green Brown Black Blue)) |}];
  print 40317;
  [%expect {| (40317 (Yellow White Red Orange Green Blue Brown Black)) |}];
  print 40316;
  [%expect {| (40316 (Yellow White Red Orange Green Blue Black Brown)) |}];
  ()
;;

let%expect_test "indices" =
  let all = ref [] in
  let add i =
    let e = Color_permutation.of_index_exn i in
    match List.find !all ~f:(fun (_, e') -> Color_permutation.equal e e') with
    | None ->
      all := (i, e) :: !all;
      e
    | Some (j, _) ->
      raise_s
        [%sexp
          "Duplicated permutation", [%here], { i : int; j : int; e : Color_permutation.t }]
  in
  for i = 0 to Color_permutation.cardinality - 1 do
    let color_permutation = add i in
    let i' = Color_permutation.to_index color_permutation in
    assert (i = i')
  done;
  let length = List.length !all in
  assert (length = Color_permutation.cardinality);
  [%expect {||}]
;;

let%expect_test "inverse" =
  let count = ref 0 in
  for i = 0 to Color_permutation.cardinality - 1 do
    let t = Color_permutation.of_index_exn i in
    let t' = Color_permutation.inverse t in
    if Color_permutation.equal t t' then incr count;
    let t'' = Color_permutation.inverse t' in
    assert (Color_permutation.equal t t'')
  done;
  print_s [%sexp (!count : int)];
  [%expect {| 764 |}]
;;
