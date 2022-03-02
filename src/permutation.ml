open! Core

type t = int [@@deriving compare, equal, hash]

let size = Cue.permutation_size
let cardinality = Float.of_int Color.cardinality ** Float.of_int size |> Float.to_int

let log2 =
  (* This function is available as [Float.log2] from OCaml 4.13. To be
     simplified upon upgrading to a more recent compiler. *)
  let log2 = lazy (Caml.Float.log 2.) in
  fun x -> Caml.Float.log x /. Lazy.force log2
;;

module Hum = struct
  type t = Color.Hum.t array [@@deriving sexp_of]
end

module Computing = struct
  type t = Color.t array

  let create_exn hum =
    if Array.length hum <> size
    then raise_s [%sexp "Invalid permutation size", [%here], (hum : Hum.t)];
    Array.map hum ~f:Color.of_hum
  ;;

  let to_hum t = t |> Array.map ~f:Color.to_hum
  let sexp_of_t t = [%sexp (to_hum t : Hum.t)]

  let of_code (i : int) : t =
    let colors = Array.create size (Color.of_index_exn 0) in
    let remainder = ref i in
    for i = 0 to size - 1 do
      let rem = !remainder mod Color.cardinality in
      remainder := !remainder / Color.cardinality;
      colors.(i) <- Color.of_index_exn rem
    done;
    colors
  ;;

  let to_code (t : t) : int =
    Array.fold_right t ~init:0 ~f:(fun color acc ->
        (acc * Color.cardinality) + Color.to_index color)
  ;;

  let analyse ~(solution : t) ~(candidate : t) =
    let solution = Array.map solution ~f:(fun i -> Some i) in
    let accounted = Array.map candidate ~f:(fun _ -> false) in
    let black = ref 0 in
    let white = ref 0 in
    Array.iteri candidate ~f:(fun i color ->
        match solution.(i) with
        | None -> assert false
        | Some color' ->
          if Color.equal color color'
          then (
            incr black;
            accounted.(i) <- true;
            solution.(i) <- None));
    Array.iteri candidate ~f:(fun i color ->
        if not accounted.(i)
        then (
          accounted.(i) <- true;
          match
            Array.find_mapi solution ~f:(fun j solution ->
                Option.bind solution ~f:(fun solution ->
                    if Color.equal color solution then Some j else None))
          with
          | None -> ()
          | Some j ->
            incr white;
            solution.(j) <- None));
    Cue.create_exn { white = !white; black = !black }
  ;;
end

let create_exn hum = hum |> Computing.create_exn |> Computing.to_code
let to_hum t = t |> Computing.of_code |> Computing.to_hum
let sexp_of_t t = [%sexp (to_hum t : Hum.t)]
let do_ansi f = if ANSITerminal.isatty.contents Core_unix.stdout then f ()

module Cache = struct
  (* solution -> candidate -> Cue.t *)
  type t = { analysed : Cue.t option array array }

  let create () =
    let analysed = Array.init cardinality ~f:(fun _ -> Array.create cardinality None) in
    { analysed }
  ;;
end

let analyse ~(cache : Cache.t) ~solution ~candidate =
  match cache.analysed.(solution).(candidate) with
  | Some v -> v
  | None ->
    let v =
      Computing.analyse
        ~solution:(Computing.of_code solution)
        ~candidate:(Computing.of_code candidate)
    in
    cache.analysed.(solution).(candidate) <- Some v;
    v
;;

module Solution_set = struct
  type nonrec t = t Queue.t [@@deriving sexp_of]

  let iter = Queue.iter
  let to_list = Queue.to_list
  let size = Queue.length

  let all =
    lazy
      (let t = Queue.create () in
       let rec aux i =
         if i >= 0
         then (
           Queue.enqueue t i;
           aux (pred i))
       in
       aux (pred cardinality);
       t)
  ;;

  let restrict t ~cache ~candidate ~cue =
    let t' = Queue.create () in
    Queue.iter t ~f:(fun solution ->
        if Cue.equal cue (analyse ~cache ~solution ~candidate)
        then Queue.enqueue t' solution);
    t'
  ;;

  let bits t = log2 (Float.of_int (size t))
end

module Outcome_by_cue = struct
  type t =
    { cue : Cue.t
    ; remains : Solution_set.t
    ; size : int
    }
  [@@deriving sexp_of]

  let bits t = log2 (Float.of_int t.size)
end

module Outcome = struct
  type permutation = t [@@deriving sexp_of]

  type t =
    { candidate : permutation
    ; by_cue : Outcome_by_cue.t array (* Sorted by increasing number of remaining sizes *)
    ; expected_score : float
    }
  [@@deriving sexp_of]

  let compute_candidate ~cache ~solution_set ~candidate : t =
    let by_cue =
      let by_cue = Array.init Cue.cardinality ~f:(fun _ -> Queue.create ()) in
      Solution_set.iter solution_set ~f:(fun solution ->
          let cue = analyse ~cache ~solution ~candidate in
          Queue.enqueue by_cue.(Cue.to_index cue) solution);
      let by_cue =
        Array.filter_mapi by_cue ~f:(fun i remains ->
            let size = Solution_set.size remains in
            if size > 0
            then Some { Outcome_by_cue.cue = Cue.of_index_exn i; remains; size }
            else None)
      in
      Array.sort by_cue ~compare:(fun t1 t2 -> Int.compare t1.size t2.size);
      by_cue
    in
    let original_size = Float.of_int (Solution_set.size solution_set) in
    let expected_score =
      Array.fold by_cue ~init:0. ~f:(fun acc t ->
          let p = Float.of_int t.size /. original_size in
          acc +. (-1. *. p *. log2 p))
    in
    { candidate; by_cue; expected_score }
  ;;
end

let step_candidate ~cache ~solution_set =
  let candidates =
    Kheap.create ~k:10 ~compare:(fun t1 t2 ->
        Float.compare t2.Outcome.expected_score t1.Outcome.expected_score)
  in
  for candidate = 0 to cardinality - 1 do
    do_ansi (fun () ->
        ANSITerminal.move_bol ();
        ANSITerminal.print_string
          []
          (sprintf
             "Permutation.step_candidate : %d / %d"
             (succ candidate)
             (cardinality - 1)));
    let computed = Outcome.compute_candidate ~cache ~solution_set ~candidate in
    if Float.( > ) computed.expected_score 0. then Kheap.add candidates computed
  done;
  do_ansi (fun () ->
      ANSITerminal.move_bol ();
      ANSITerminal.erase Eol);
  Kheap.to_list candidates
;;

module Private = struct
  module Computing = Computing
end
