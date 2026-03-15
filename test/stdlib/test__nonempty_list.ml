(*********************************************************************************)
(*  super-master-mind: A solver for the super master mind game                   *)
(*  SPDX-FileCopyrightText: 2021-2025 Mathieu Barbin <mathieu.barbin@gmail.com>  *)
(*  SPDX-License-Identifier: MIT                                                 *)
(*********************************************************************************)

let to_dyn t = Dyn.list Dyn.int (Nonempty_list.to_list t)
let print t = print_dyn (to_dyn t)

let%expect_test "singleton" =
  print (Nonempty_list.singleton 42);
  [%expect {| [ 42 ] |}];
  ()
;;

let%expect_test "hd" =
  print_dyn (Dyn.int (Nonempty_list.hd (Nonempty_list.of_list_exn [ 1; 2; 3 ])));
  [%expect {| 1 |}];
  ()
;;

let%expect_test "tl" =
  print_dyn (Dyn.list Dyn.int (Nonempty_list.tl (Nonempty_list.of_list_exn [ 1; 2; 3 ])));
  [%expect {| [ 2; 3 ] |}];
  print_dyn (Dyn.list Dyn.int (Nonempty_list.tl (Nonempty_list.singleton 1)));
  [%expect {| [] |}];
  ()
;;

let%expect_test "cons" =
  print (Nonempty_list.cons 0 (Nonempty_list.of_list_exn [ 1; 2 ]));
  [%expect {| [ 0; 1; 2 ] |}];
  ()
;;

let%expect_test "of_list_exn" =
  print (Nonempty_list.of_list_exn [ 1; 2; 3 ]);
  [%expect {| [ 1; 2; 3 ] |}];
  ()
;;

let%expect_test "of_list_exn empty" =
  require_does_raise (fun () -> Nonempty_list.of_list_exn []);
  [%expect {| Invalid_argument("Nonempty_list.of_list_exn") |}];
  ()
;;

let%expect_test "to_list" =
  print_dyn (Dyn.list Dyn.int (Nonempty_list.to_list Nonempty_list.(1 :: [ 2; 3 ])));
  [%expect {| [ 1; 2; 3 ] |}];
  ()
;;

let%expect_test "to_array" =
  let arr = Nonempty_list.to_array (Nonempty_list.of_list_exn [ 1; 2; 3 ]) in
  print_dyn (Dyn.list Dyn.int (Array.to_list arr));
  [%expect {| [ 1; 2; 3 ] |}];
  ()
;;

let%expect_test "length" =
  print_dyn (Dyn.int (Nonempty_list.length (Nonempty_list.singleton 1)));
  [%expect {| 1 |}];
  print_dyn (Dyn.int (Nonempty_list.length (Nonempty_list.of_list_exn [ 1; 2; 3 ])));
  [%expect {| 3 |}];
  ()
;;

let%expect_test "init" =
  print (Nonempty_list.init 4 ~f:(fun i -> i * 10));
  [%expect {| [ 0; 10; 20; 30 ] |}];
  ()
;;

let%expect_test "init invalid" =
  require_does_raise (fun () -> Nonempty_list.init 0 ~f:Fun.id);
  [%expect {| Invalid_argument("Nonempty_list.init") |}];
  ()
;;

let%expect_test "append" =
  print (Nonempty_list.append (Nonempty_list.of_list_exn [ 1; 2 ]) [ 3; 4 ]);
  [%expect {| [ 1; 2; 3; 4 ] |}];
  ()
;;

let%expect_test "map" =
  print (Nonempty_list.map (Nonempty_list.of_list_exn [ 1; 2; 3 ]) ~f:(fun x -> x * 10));
  [%expect {| [ 10; 20; 30 ] |}];
  ()
;;

let%expect_test "mapi" =
  print
    (Nonempty_list.mapi (Nonempty_list.of_list_exn [ 10; 20; 30 ]) ~f:(fun i x -> i + x));
  [%expect {| [ 10; 21; 32 ] |}];
  ()
;;

let%expect_test "iter" =
  Nonempty_list.iter
    (Nonempty_list.of_list_exn [ 1; 2; 3 ])
    ~f:(fun x -> print_dyn (Dyn.int x));
  [%expect
    {|
    1
    2
    3
    |}];
  ()
;;

let%expect_test "fold" =
  let t = Nonempty_list.of_list_exn [ 1; 2; 3 ] in
  print_dyn (Dyn.int (Nonempty_list.fold t ~init:0 ~f:(fun acc x -> acc + x)));
  [%expect {| 6 |}];
  ()
;;

let%expect_test "find" =
  let t = Nonempty_list.of_list_exn [ 1; 2; 3 ] in
  print_dyn (Dyn.option Dyn.int (Nonempty_list.find t ~f:(fun x -> x = 2)));
  [%expect {| Some 2 |}];
  print_dyn (Dyn.option Dyn.int (Nonempty_list.find t ~f:(fun x -> x = 5)));
  [%expect {| None |}];
  ()
;;

let%expect_test "filter" =
  let result =
    Nonempty_list.filter
      (Nonempty_list.of_list_exn [ 1; 2; 3; 4; 5 ])
      ~f:(fun x -> x mod 2 = 0)
  in
  print_dyn (Dyn.list Dyn.int result);
  [%expect {| [ 2; 4 ] |}];
  ()
;;

let%expect_test "filter_map" =
  let result =
    Nonempty_list.filter_map
      (Nonempty_list.of_list_exn [ 1; 2; 3; 4; 5 ])
      ~f:(fun x -> if x mod 2 = 0 then Some (x * 10) else None)
  in
  print_dyn (Dyn.list Dyn.int result);
  [%expect {| [ 20; 40 ] |}];
  ()
;;

let%expect_test "concat_map" =
  let result =
    Nonempty_list.concat_map
      (Nonempty_list.of_list_exn [ 1; 2; 3 ])
      ~f:(fun x -> Nonempty_list.of_list_exn [ x; x * 10 ])
  in
  print result;
  [%expect {| [ 1; 10; 2; 20; 3; 30 ] |}];
  ()
;;

let%expect_test "max_elt" =
  let result =
    Nonempty_list.max_elt
      (Nonempty_list.of_list_exn [ 3; 1; 4; 1; 5 ])
      ~compare:Int.compare
  in
  print_dyn (Dyn.int result);
  [%expect {| 5 |}];
  ()
;;

let%expect_test "sum" =
  let module I = struct
    type t = int

    let zero = 0
    let ( + ) = ( + )
  end
  in
  let result =
    Nonempty_list.sum (module I) (Nonempty_list.of_list_exn [ 1; 2; 3; 4 ]) ~f:Fun.id
  in
  print_dyn (Dyn.int result);
  [%expect {| 10 |}];
  ()
;;

let%expect_test "equal" =
  let eq a b = Nonempty_list.equal Int.equal a b in
  print_dyn (Dyn.bool (eq Nonempty_list.(1 :: [ 2 ]) Nonempty_list.(1 :: [ 2 ])));
  [%expect {| true |}];
  print_dyn (Dyn.bool (eq Nonempty_list.(1 :: [ 2 ]) Nonempty_list.(1 :: [ 3 ])));
  [%expect {| false |}];
  ()
;;

let%expect_test "compare" =
  let cmp a b = Nonempty_list.compare Int.compare a b in
  print_dyn (Ordering.to_dyn (cmp Nonempty_list.(1 :: [ 2 ]) Nonempty_list.(1 :: [ 2 ])));
  [%expect {| Eq |}];
  print_dyn (Ordering.to_dyn (cmp Nonempty_list.(1 :: [ 2 ]) Nonempty_list.(1 :: [ 3 ])));
  [%expect {| Lt |}];
  ()
;;

let%expect_test "zip" =
  let a = Nonempty_list.of_list_exn [ 1; 2; 3 ] in
  let b = Nonempty_list.of_list_exn [ 10; 20; 30 ] in
  (match Nonempty_list.zip a b with
   | Ok zipped ->
     print_dyn
       (Dyn.list
          (fun (x, y) -> Dyn.Tuple [ Dyn.int x; Dyn.int y ])
          (Nonempty_list.to_list zipped))
   | Unequal_lengths -> print_dyn (Dyn.string "unequal"));
  [%expect {| [ (1, 10); (2, 20); (3, 30) ] |}];
  let c = Nonempty_list.of_list_exn [ 1; 2 ] in
  (match Nonempty_list.zip c b with
   | Ok _ -> print_dyn (Dyn.string "ok")
   | Unequal_lengths -> print_dyn (Dyn.string "unequal"));
  [%expect {| "unequal" |}];
  ()
;;

let%expect_test "pattern matching" =
  let show (t : int Nonempty_list.t) =
    match t with
    | [ x ] -> print_dyn (Dyn.variant "One" [ Dyn.int x ])
    | [ x; y ] -> print_dyn (Dyn.variant "Two" [ Dyn.int x; Dyn.int y ])
    | _ :: _ :: _ :: _ -> print_dyn (Dyn.variant "Many" [])
  in
  show (Nonempty_list.singleton 1);
  [%expect {| One 1 |}];
  show (Nonempty_list.of_list_exn [ 1; 2 ]);
  [%expect {| Two (1, 2) |}];
  show (Nonempty_list.of_list_exn [ 1; 2; 3 ]);
  [%expect {| Many |}];
  ()
;;

let%expect_test "cons construction" =
  print Nonempty_list.(1 :: [ 2; 3 ]);
  [%expect {| [ 1; 2; 3 ] |}];
  ()
;;
