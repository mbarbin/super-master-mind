open Super_master_mind

let%expect_test "all" =
  print_s [%sexp (Codes.size Codes.all : int)];
  [%expect {| 32768 |}];
  print_s [%sexp (Codes.bits Codes.all : float)];
  [%expect {| 15 |}];
  print_s [%sexp { is_empty = (Codes.is_empty Codes.all : bool) }];
  [%expect {| ((is_empty false)) |}]
;;

let%expect_test "to_list" =
  let test t = print_s [%sexp (List.length (Codes.to_list t) : int)] in
  test Codes.all;
  [%expect {| 32768 |}];
  let t =
    Codes.filter
      Codes.all
      ~candidate:(Code.create_exn [| Black; Blue; Brown; Green; Orange |])
      ~cue:(Cue.create_exn { white = 2; black = 3 })
  in
  test t;
  [%expect {| 10 |}];
  (* sexp_of_t *)
  print_s [%sexp (Codes.all : Codes.t)];
  [%expect {| All |}];
  print_s [%sexp (t : Codes.t)];
  [%expect
    {|
    (Only
     (queue
      ((Orange Blue Brown Green Black) (Black Orange Brown Green Blue)
       (Black Blue Orange Green Brown) (Black Blue Brown Orange Green)
       (Green Blue Brown Black Orange) (Black Green Brown Blue Orange)
       (Black Blue Green Brown Orange) (Brown Blue Black Green Orange)
       (Black Brown Blue Green Orange) (Blue Black Brown Green Orange)))) |}];
  ()
;;

let%expect_test "filter" =
  List.iter (force Cue.all) ~f:(fun cue ->
    let t =
      Codes.filter
        Codes.all
        ~candidate:(Code.create_exn [| Black; Blue; Brown; Green; Orange |])
        ~cue
    in
    print_s [%sexp { cue : Cue.t; size_remaining = (Codes.size t : int) }]);
  [%expect
    {|
    ((cue ((white 0) (black 0))) (size_remaining 243))
    ((cue ((white 0) (black 1))) (size_remaining 1280))
    ((cue ((white 0) (black 2))) (size_remaining 1250))
    ((cue ((white 0) (black 3))) (size_remaining 360))
    ((cue ((white 0) (black 4))) (size_remaining 35))
    ((cue ((white 0) (black 5))) (size_remaining 1))
    ((cue ((white 1) (black 0))) (size_remaining 2625))
    ((cue ((white 1) (black 1))) (size_remaining 4880))
    ((cue ((white 1) (black 2))) (size_remaining 1650))
    ((cue ((white 1) (black 3))) (size_remaining 120))
    ((cue ((white 2) (black 0))) (size_remaining 7070))
    ((cue ((white 2) (black 1))) (size_remaining 4680))
    ((cue ((white 2) (black 2))) (size_remaining 510))
    ((cue ((white 2) (black 3))) (size_remaining 10))
    ((cue ((white 3) (black 0))) (size_remaining 5610))
    ((cue ((white 3) (black 1))) (size_remaining 1120))
    ((cue ((white 3) (black 2))) (size_remaining 20))
    ((cue ((white 4) (black 0))) (size_remaining 1215))
    ((cue ((white 4) (black 1))) (size_remaining 45))
    ((cue ((white 5) (black 0))) (size_remaining 44)) |}]
;;
