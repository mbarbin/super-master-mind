open! Core
open! Import

let step ~cache ~possible_solutions ~solution =
  let size = Permutations.size possible_solutions in
  let () = if size <= 0 then raise_s [%sexp "Invalid possible_solutions", [%here]] in
  print_endline "STEP";
  print_s
    [%sexp
      { size = (Permutations.size possible_solutions : int)
      ; bits = (Permutations.bits possible_solutions : float)
      }];
  let guesss = Guess.compute_k_best ~cache ~possible_solutions ~k:5 in
  List.iter guesss ~f:(fun guess ->
      let hum = Permutation.to_hum guess.candidate in
      print_s [%sexp (guess.expected_bits : Float.t), (hum : Permutation.Hum.t)]);
  match guesss with
  | [] -> None
  | { candidate; expected_bits; _ } :: _ ->
    let cue = Permutation.analyse ~cache ~solution ~candidate in
    let new_set = Permutations.filter possible_solutions ~cache ~candidate ~cue in
    if Permutations.size new_set = 0
    then None
    else (
      let actual_bits =
        let original_bits = Permutations.bits possible_solutions in
        let new_bits = Permutations.bits new_set in
        original_bits -. new_bits
      in
      print_s
        [%sexp
          { candidate = (Permutation.to_hum candidate : Permutation.Hum.t)
          ; cue : Cue.t
          ; expected_bits : float
          ; actual_bits : float
          }];
      Some new_set)
;;

let step_with_candidate ~cache ~solution ~possible_solutions ~candidate =
  print_endline "STEP";
  print_s
    [%sexp
      { size = (Permutations.size possible_solutions : int)
      ; bits = (Permutations.bits possible_solutions : float)
      }];
  let cue = Permutation.analyse ~cache ~solution ~candidate in
  let new_set = Permutations.filter possible_solutions ~cache ~candidate ~cue in
  let actual_bits =
    let original_bits = Permutations.bits possible_solutions in
    let new_bits = Permutations.bits new_set in
    original_bits -. new_bits
  in
  print_s
    [%sexp
      { candidate = (Permutation.to_hum candidate : Permutation.Hum.t)
      ; cue : Cue.t
      ; actual_bits : float
      }];
  new_set
;;

let loop ~cache ~solution =
  let rec aux ~possible_solutions =
    match step ~cache ~possible_solutions ~solution with
    | None -> ()
    | Some possible_solutions ->
      if Permutations.size possible_solutions > 1
      then aux ~possible_solutions
      else (
        match Permutations.to_list possible_solutions with
        | [] -> assert false
        | found :: _ ->
          assert (Permutation.equal solution found);
          print_s [%sexp { solution = (Permutation.to_hum found : Permutation.Hum.t) }])
  in
  let possible_solutions = Lazy.force Permutations.all in
  let possible_solutions =
    step_with_candidate
      ~cache
      ~solution
      ~possible_solutions
      ~candidate:(Permutation.create_exn [| Black; Blue; Brown; Green; Orange |])
  in
  aux ~possible_solutions
;;

let cmd =
  Command.basic
    ~summary:"run through an example"
    (let%map_open.Command () = return () in
     fun () ->
       let solution = Permutation.create_exn [| Green; Blue; Orange; White; Red |] in
       print_endline "Allocating cache";
       let cache = Permutation.Cache.create () in
       print_endline "Cache allocated";
       loop ~cache ~solution)
;;
