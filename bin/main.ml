open! Core
open Super_master_mind

let step ~cache ~solution_set ~solution =
  let size = Permutation.Solution_set.size solution_set in
  let () = if size <= 0 then raise_s [%sexp "Invalid solution_set", [%here]] in
  print_endline "STEP";
  print_s
    [%sexp
      { size = (Permutation.Solution_set.size solution_set : int)
      ; bits = (Permutation.Solution_set.bits solution_set : float)
      }];
  let outcomes = Permutation.step_candidate ~cache ~solution_set in
  let first_5 = List.take outcomes 5 in
  List.iter first_5 ~f:(fun t ->
      let hum = Permutation.to_hum t.candidate in
      print_s [%sexp (t.expected_score : Float.t), (hum : Permutation.Hum.t)]);
  match outcomes with
  | [] -> None
  | { candidate; expected_score; _ } :: _ ->
    let cue = Permutation.analyse ~cache ~solution ~candidate in
    let new_set = Permutation.Solution_set.restrict solution_set ~cache ~candidate ~cue in
    if Permutation.Solution_set.size new_set = 0
    then None
    else (
      let actual_score =
        let original_bits = Permutation.Solution_set.bits solution_set in
        let new_bits = Permutation.Solution_set.bits new_set in
        original_bits -. new_bits
      in
      print_s
        [%sexp
          { candidate = (Permutation.to_hum candidate : Permutation.Hum.t)
          ; cue : Cue.t
          ; expected_score : float
          ; actual_score : float
          }];
      Some new_set)
;;

let step_with_candidate ~cache ~solution ~solution_set ~candidate =
  print_endline "STEP";
  print_s
    [%sexp
      { size = (Permutation.Solution_set.size solution_set : int)
      ; bits = (Permutation.Solution_set.bits solution_set : float)
      }];
  let cue = Permutation.analyse ~cache ~solution ~candidate in
  let new_set = Permutation.Solution_set.restrict solution_set ~cache ~candidate ~cue in
  let actual_score =
    let original_bits = Permutation.Solution_set.bits solution_set in
    let new_bits = Permutation.Solution_set.bits new_set in
    original_bits -. new_bits
  in
  print_s
    [%sexp
      { candidate = (Permutation.to_hum candidate : Permutation.Hum.t)
      ; cue : Cue.t
      ; actual_score : float
      }];
  new_set
;;

let loop ~cache ~solution =
  let rec aux ~solution_set =
    match step ~cache ~solution_set ~solution with
    | None -> ()
    | Some solution_set ->
      if Permutation.Solution_set.size solution_set > 1
      then aux ~solution_set
      else (
        match Permutation.Solution_set.to_list solution_set with
        | [] -> assert false
        | found :: _ ->
          assert (Permutation.equal solution found);
          print_s [%sexp { solution = (Permutation.to_hum found : Permutation.Hum.t) }])
  in
  let solution_set = Lazy.force Permutation.Solution_set.all in
  let solution_set =
    step_with_candidate
      ~cache
      ~solution
      ~solution_set
      ~candidate:(Permutation.create_exn [| Black; Blue; Brown; Green; Orange |])
  in
  aux ~solution_set
;;

let cache = lazy (Permutation.Cache.create ())

let () =
  let solution = Permutation.create_exn [| Green; Blue; Orange; White; Red |] in
  print_endline "Computing cache";
  let cache = Lazy.force cache in
  print_endline "Cache computed";
  loop ~cache ~solution
;;
