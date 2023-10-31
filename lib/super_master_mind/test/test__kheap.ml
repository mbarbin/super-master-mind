open Super_master_mind

let%expect_test "kheap" =
  let h = Kheap.create ~k:3 ~compare:Int.compare in
  let print () = print_s [%sexp (h : int Kheap.t)] in
  print ();
  [%expect {| () |}];
  Kheap.add h 4;
  print ();
  [%expect {| (4) |}];
  Kheap.add h 6;
  print ();
  [%expect {| (4 6) |}];
  Kheap.add h 3;
  print ();
  [%expect {| (3 4 6) |}];
  Kheap.add h 5;
  print ();
  [%expect {| (3 4 5) |}];
  Kheap.add h 2;
  print ();
  [%expect {| (2 3 4) |}]
;;
