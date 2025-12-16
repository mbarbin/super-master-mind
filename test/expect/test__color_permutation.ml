(*********************************************************************************)
(*  super-master-mind: A solver for the super master mind game                   *)
(*  SPDX-FileCopyrightText: 2021-2025 Mathieu Barbin <mathieu.barbin@gmail.com>  *)
(*  SPDX-License-Identifier: MIT                                                 *)
(*********************************************************************************)

let%expect_test "bounds" =
  let color_cardinality = Lazy.force Color.cardinality in
  let zero =
    Array.init color_cardinality ~f:(fun i -> i |> Color.of_index_exn |> Color.to_hum)
    |> Color_permutation.create_exn
  in
  let max =
    Array.init color_cardinality ~f:(fun i ->
      Color.of_index_exn (color_cardinality - 1 - i) |> Color.to_hum)
    |> Color_permutation.create_exn
  in
  let test i expected =
    let t = Color_permutation.of_index_exn i in
    if Color_permutation.equal t expected
    then print_dyn (Dyn.Tuple [ Dyn.int i; Color_permutation.to_dyn t ])
    else
      Code_error.raise
        "Unexpected value."
        [ "i", Dyn.int i
        ; "expected", Color_permutation.to_dyn expected
        ; "got", Color_permutation.to_dyn t
        ] [@coverage off]
  in
  test 0 zero;
  [%expect {| (0, [| Black;  Blue;  Brown;  Green;  Orange;  Red;  White;  Yellow |]) |}];
  test (Lazy.force Color_permutation.cardinality - 1) max;
  [%expect
    {| (40319, [| Yellow;  White;  Red;  Orange;  Green;  Brown;  Blue;  Black |]) |}]
;;

let%expect_test "sexp_of" =
  let print i =
    print_dyn
      (Dyn.Tuple
         [ Dyn.int i; Color_permutation.to_dyn (Color_permutation.of_index_exn i) ])
  in
  print 0;
  [%expect {| (0, [| Black;  Blue;  Brown;  Green;  Orange;  Red;  White;  Yellow |]) |}];
  print 1;
  [%expect {| (1, [| Black;  Blue;  Brown;  Green;  Orange;  Red;  Yellow;  White |]) |}];
  print 2;
  [%expect {| (2, [| Black;  Blue;  Brown;  Green;  Orange;  White;  Red;  Yellow |]) |}];
  print 3;
  [%expect {| (3, [| Black;  Blue;  Brown;  Green;  Orange;  White;  Yellow;  Red |]) |}];
  print 4;
  [%expect {| (4, [| Black;  Blue;  Brown;  Green;  Orange;  Yellow;  Red;  White |]) |}];
  print 40319;
  [%expect
    {| (40319, [| Yellow;  White;  Red;  Orange;  Green;  Brown;  Blue;  Black |]) |}];
  print 40318;
  [%expect
    {| (40318, [| Yellow;  White;  Red;  Orange;  Green;  Brown;  Black;  Blue |]) |}];
  print 40317;
  [%expect
    {| (40317, [| Yellow;  White;  Red;  Orange;  Green;  Blue;  Brown;  Black |]) |}];
  print 40316;
  [%expect
    {| (40316, [| Yellow;  White;  Red;  Orange;  Green;  Blue;  Black;  Brown |]) |}];
  ()
;;

let%expect_test "indices" =
  let all = Hashtbl.create (Lazy.force Color_permutation.cardinality) in
  let add i =
    let e = Color_permutation.of_index_exn i in
    match Hashtbl.find_opt all e with
    | None ->
      Hashtbl.set all ~key:e ~data:i;
      e
    | Some j ->
      Code_error.raise
        "Duplicated permutation."
        [ "i", Dyn.int i; "j", Dyn.int j; "e", Color_permutation.to_dyn e ]
  in
  for i = 0 to Lazy.force Color_permutation.cardinality - 1 do
    let color_permutation = add i in
    let i' = Color_permutation.to_index color_permutation in
    assert (i = i')
  done;
  let length = Hashtbl.length all in
  assert (length = Lazy.force Color_permutation.cardinality);
  [%expect {||}];
  require_does_raise (fun () : Color_permutation.t ->
    Color_permutation.of_index_exn (Lazy.force Color_permutation.cardinality));
  [%expect {| ("Index out of bounds.", { index = 40320; cardinality = 40320 }) |}];
  (* Testing the [add] function itself. *)
  require_does_raise (fun () : Color_permutation.t -> add 0);
  [%expect
    {|
    ("Duplicated permutation.",
     { i = 0
     ; j = 0
     ; e = [| Black;  Blue;  Brown;  Green;  Orange;  Red;  White;  Yellow |]
     })
    |}];
  ()
;;

let%expect_test "inverse" =
  let count = ref 0 in
  for i = 0 to Lazy.force Color_permutation.cardinality - 1 do
    let t = Color_permutation.of_index_exn i in
    let t' = Color_permutation.inverse t in
    if Color_permutation.equal t t' then incr count;
    let t'' = Color_permutation.inverse t' in
    assert (Color_permutation.equal t t'')
  done;
  print_dyn (Dyn.int !count);
  [%expect {| 764 |}]
;;

let%expect_test "to_hum | create_exn" =
  for i = 0 to Lazy.force Color_permutation.cardinality - 1 do
    let t = Color_permutation.of_index_exn i in
    let hum = Color_permutation.to_hum t in
    let t' = Color_permutation.create_exn hum in
    if not (Color_permutation.equal t t')
    then
      Code_error.raise
        "Color_permutation does not round-trip."
        [ "t", Color_permutation.to_dyn t
        ; "hum", Dyn.array Color.Hum.to_dyn hum
        ; "t'", Color_permutation.to_dyn t'
        ] [@coverage off]
  done;
  [%expect {||}]
;;

let%expect_test "find_nth" =
  let test a n f =
    let result = Color_permutation.Private.find_nth a ~n ~f in
    print_dyn (Dyn.option Dyn.int result)
  in
  test [||] 0 (fun _ -> (assert false [@coverage off]));
  [%expect {| None |}];
  test [||] 1 (fun _ -> (assert false [@coverage off]));
  [%expect {| None |}];
  test [| true |] 0 Fun.id;
  [%expect {| Some 0 |}];
  test [| true |] 1 Fun.id;
  [%expect {| None |}];
  test [| false; true |] 0 Fun.id;
  [%expect {| Some 1 |}];
  test [| false; true; false; true; false; true |] 1 Fun.id;
  [%expect {| Some 3 |}];
  test [| false; true; false; true; false; true |] 2 Fun.id;
  [%expect {| Some 5 |}];
  ()
;;
