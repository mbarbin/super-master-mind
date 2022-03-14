open! Core

type t = Color.t array [@@deriving compare, equal, sexp]

let hash t = Array.fold t ~init:1023 ~f:(fun acc i -> Hashtbl.hash (acc, Color.hash i))
let hash_fold_t state t = Array.fold t ~init:state ~f:Color.hash_fold_t
let map_color t color = t.(Color.to_index color)

let inverse t =
  let t' = Array.create ~len:Color.cardinality (Color.of_index_exn 0) in
  for i = 0 to Color.cardinality - 1 do
    t'.(Color.to_index t.(i)) <- Color.of_index_exn i
  done;
  t'
;;

let to_hum t = Array.map t ~f:Color.to_hum

let create_exn hums =
  let colors = Array.map hums ~f:Color.of_hum in
  let visited = Array.create ~len:Color.cardinality false in
  let count = ref 0 in
  Array.iter colors ~f:(fun color ->
      let index = Color.to_index color in
      if not visited.(index)
      then (
        visited.(index) <- true;
        incr count));
  if Array.length colors <> Color.cardinality || !count <> Color.cardinality
  then raise_s [%sexp "Invalid color permutation", [%here], (hums : Color.Hum.t array)];
  colors
;;

let factorial =
  let results = Array.create ~len:(Color.cardinality + 1) 1 in
  for i = 2 to Color.cardinality do
    results.(i) <- i * results.(pred i)
  done;
  results
;;

let cardinality = factorial.(Color.cardinality)

(* Find the nth index in an array of values that verify some predicate
   [f]. nth-index is 0-based. *)
let find_nth array ~n ~f =
  let rec aux k i =
    if i >= Array.length array
    then None
    else (
      let k = if f array.(i) then succ k else k in
      if k >= n then Some i else aux k (succ i))
  in
  aux (-1) 0
;;

let of_index_exn index =
  if not (0 <= index && index < cardinality)
  then raise_s [%sexp "Index out of bounds", [%here], (index : int)];
  let factorial_decomposition = Array.create ~len:Color.cardinality 0 in
  let remainder = ref index in
  for i = Color.cardinality - 1 downto 1 do
    factorial_decomposition.(i) <- !remainder / factorial.(i);
    remainder := !remainder mod factorial.(i)
  done;
  let available_colors = Array.create ~len:Color.cardinality true in
  let t = Array.create ~len:Color.cardinality (Color.of_index_exn 0) in
  for i = 0 to Color.cardinality - 1 do
    match
      find_nth
        available_colors
        ~n:factorial_decomposition.(Color.cardinality - 1 - i)
        ~f:Fn.id
    with
    | Some j ->
      available_colors.(j) <- false;
      t.(i) <- Color.of_index_exn j
    | None ->
      raise_s
        [%sexp
          "Unexpected decomposition"
          , { index : int
            ; factorial_decomposition : int array
            ; available_colors : bool array
            ; t : Color.t array
            }]
  done;
  t
;;

let to_index t =
  let available_colors = Array.create ~len:Color.cardinality true in
  let factorial_decomposition = Array.create ~len:Color.cardinality 0 in
  for i = 0 to Color.cardinality - 1 do
    let color = Color.to_index t.(i) in
    let count = ref 0 in
    for j = 0 to color - 1 do
      if available_colors.(j) then incr count
    done;
    available_colors.(color) <- false;
    factorial_decomposition.(Color.cardinality - 1 - i) <- !count
  done;
  Array.foldi factorial_decomposition ~init:0 ~f:(fun i acc d ->
      acc + (d * factorial.(i)))
;;
