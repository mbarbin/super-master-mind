(*********************************************************************************)
(*  super-master-mind: A solver for the super master mind game                   *)
(*  SPDX-FileCopyrightText: 2021-2025 Mathieu Barbin <mathieu.barbin@gmail.com>  *)
(*  SPDX-License-Identifier: MIT                                                 *)
(*********************************************************************************)

let%expect_test "kheap" =
  let h = Kheap.create ~k:3 ~compare:Int.compare in
  let print () = print_dyn (Kheap.to_dyn Dyn.int h) in
  print ();
  [%expect {| [] |}];
  Kheap.add h 4;
  print ();
  [%expect {| [ 4 ] |}];
  Kheap.add h 6;
  print ();
  [%expect {| [ 4; 6 ] |}];
  Kheap.add h 3;
  print ();
  [%expect {| [ 3; 4; 6 ] |}];
  Kheap.add h 5;
  print ();
  [%expect {| [ 3; 4; 5 ] |}];
  Kheap.add h 2;
  print ();
  [%expect {| [ 2; 3; 4 ] |}]
;;

(* To observe how values that compare equal are ordered, we need values that
   remain distinguishable once compared. We use pairs that are compared on
   their first component only, and tag their second component. *)
let%expect_test "equal values" =
  let h = Kheap.create ~k:3 ~compare:(fun (i, _) (j, _) -> Int.compare i j) in
  let print () =
    print_dyn (Kheap.to_dyn (fun (i, tag) -> Dyn.Tuple [ Dyn.int i; Dyn.string tag ]) h)
  in
  (* Values that compare equal are kept in the order in which they were added. *)
  Kheap.add h (1, "a");
  Kheap.add h (1, "b");
  print ();
  [%expect {| [ (1, "a"); (1, "b") ] |}];
  (* A smaller value takes its place before them. *)
  Kheap.add h (0, "c");
  print ();
  [%expect {| [ (0, "c"); (1, "a"); (1, "b") ] |}];
  (* Now that the heap is full, a value that compares equal to the ones already
     present would go after them, and is thus discarded. *)
  Kheap.add h (1, "d");
  print ();
  [%expect {| [ (0, "c"); (1, "a"); (1, "b") ] |}]
;;
