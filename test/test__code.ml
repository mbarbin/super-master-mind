open! Core
open Super_master_mind

let%expect_test "sexp_of_t" =
  let t = Code.create_exn [| Green; Blue; Orange; White; Red |] in
  print_s [%sexp (t : Code.t)];
  [%expect {| (Green Blue Orange White Red) |}]
;;

let%expect_test "analyse" =
  let tested = Array.create ~len:Cue.cardinality false in
  let test ~solution ~candidate =
    let solution = Code.create_exn solution
    and candidate = Code.create_exn candidate in
    let cue = Code.analyse ~solution ~candidate in
    tested.(Cue.to_index cue) <- true;
    print_s [%sexp (cue : Cue.t)];
    (* Check that [Code.analyse] is commutative. *)
    let cue' = Code.analyse ~solution:candidate ~candidate:solution in
    assert (Cue.equal cue cue')
  in
  let solution : Color.Hum.t array = [| Black; Blue; Brown; Green; Orange |] in
  test ~solution ~candidate:[| Red; White; Yellow; Red; Red |];
  [%expect {| ((white 0) (black 0)) |}];
  test ~solution ~candidate:[| Black; White; Yellow; Red; Red |];
  [%expect {| ((white 0) (black 1)) |}];
  test ~solution ~candidate:[| Black; Black; Yellow; Red; Red |];
  [%expect {| ((white 0) (black 1)) |}];
  test ~solution ~candidate:[| Black; Black; Yellow; Orange; Orange |];
  [%expect {| ((white 0) (black 2)) |}];
  test ~solution ~candidate:[| Black; Brown; Brown; Orange; Orange |];
  [%expect {| ((white 0) (black 3)) |}];
  test ~solution ~candidate:[| Black; Brown; Brown; Green; Orange |];
  [%expect {| ((white 0) (black 4)) |}];
  test ~solution ~candidate:[| Black; Blue; Brown; Green; Orange |];
  [%expect {| ((white 0) (black 5)) |}];
  test ~solution ~candidate:[| Red; White; Yellow; Red; Black |];
  [%expect {| ((white 1) (black 0)) |}];
  test ~solution ~candidate:[| Red; White; Yellow; Black; Black |];
  [%expect {| ((white 1) (black 0)) |}];
  test ~solution ~candidate:[| Black; Black; Blue; Yellow; White |];
  [%expect {| ((white 1) (black 1)) |}];
  test ~solution ~candidate:[| Black; Black; Blue; Green; White |];
  [%expect {| ((white 1) (black 2)) |}];
  test ~solution ~candidate:[| Black; Black; Blue; Green; Orange |];
  [%expect {| ((white 1) (black 3)) |}];
  test ~solution ~candidate:[| Red; White; Yellow; Blue; Black |];
  [%expect {| ((white 2) (black 0)) |}];
  test ~solution ~candidate:[| Red; White; Brown; Blue; Black |];
  [%expect {| ((white 2) (black 1)) |}];
  test ~solution ~candidate:[| Red; Blue; Brown; Orange; Black |];
  [%expect {| ((white 2) (black 2)) |}];
  test ~solution ~candidate:[| Green; Blue; Brown; Black; Orange |];
  [%expect {| ((white 2) (black 3)) |}];
  test ~solution ~candidate:[| Green; White; Yellow; Blue; Black |];
  [%expect {| ((white 3) (black 0)) |}];
  test ~solution ~candidate:[| Green; White; Brown; Blue; Black |];
  [%expect {| ((white 3) (black 1)) |}];
  test ~solution ~candidate:[| Green; Blue; Brown; Orange; Black |];
  [%expect {| ((white 3) (black 2)) |}];
  test ~solution ~candidate:[| Green; Orange; Yellow; Blue; Black |];
  [%expect {| ((white 4) (black 0)) |}];
  test ~solution ~candidate:[| Green; Orange; Brown; Blue; Black |];
  [%expect {| ((white 4) (black 1)) |}];
  test ~solution ~candidate:[| Green; Brown; Orange; Blue; Black |];
  [%expect {| ((white 5) (black 0)) |}];
  let not_tested =
    Array.find_mapi tested ~f:(fun i tested ->
        if not tested then Some (Cue.of_index_exn i) else None)
  in
  print_s [%sexp (not_tested : Cue.t option)];
  [%expect {| () |}]
;;

let%expect_test "repetition of colors in the solution" =
  let test ~solution ~candidate =
    let cue =
      Code.(analyse ~solution:(create_exn solution) ~candidate:(create_exn candidate))
    in
    print_s [%sexp (cue : Cue.t)]
  in
  let solution : Color.Hum.t array = [| Black; Green; Brown; Green; Brown |] in
  test ~solution ~candidate:[| Red; White; Yellow; Red; Red |];
  [%expect {| ((white 0) (black 0)) |}];
  test ~solution ~candidate:[| Green; White; Green; Red; Red |];
  [%expect {| ((white 2) (black 0)) |}];
  test ~solution ~candidate:[| Green; Green; Green; Red; Red |];
  [%expect {| ((white 1) (black 1)) |}];
  test ~solution ~candidate:[| Green; Green; Green; Brown; Red |];
  [%expect {| ((white 2) (black 1)) |}]
;;

let%expect_test "indices" =
  for i = 0 to Code.cardinality - 1 do
    let code = Code.of_index_exn i in
    let index = Code.to_index code in
    let hum = Code.to_hum code in
    let code' = Code.create_exn hum in
    assert (Int.equal i index);
    assert (Code.equal code code')
  done;
  [%expect {||}]
;;
