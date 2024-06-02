type t = Color.t array [@@deriving compare, equal, sexp]

let identity = lazy (Array.init (force Color.cardinality) ~f:Color.of_index_exn)
let hash t = Array.fold t ~init:1023 ~f:(fun acc i -> Hashtbl.hash (acc, Color.hash i))
let hash_fold_t state t = Array.fold t ~init:state ~f:Color.hash_fold_t
let map_color t color = t.(Color.to_index color)

let inverse t =
  let t' = Array.create ~len:(force Color.cardinality) (Color.of_index_exn 0) in
  for i = 0 to force Color.cardinality - 1 do
    t'.(Color.to_index t.(i)) <- Color.of_index_exn i
  done;
  t'
;;

let to_hum t = Array.map t ~f:Color.to_hum

let create_exn hums =
  let colors = Array.map hums ~f:Color.of_hum in
  let color_cardinality = force Color.cardinality in
  let visited = Array.create ~len:color_cardinality false in
  let count = ref 0 in
  Array.iter colors ~f:(fun color ->
    let index = Color.to_index color in
    if not visited.(index)
    then (
      visited.(index) <- true;
      Int.incr count));
  if Array.length colors <> color_cardinality || !count <> color_cardinality
  then raise_s [%sexp "Invalid color permutation", (hums : Color.Hum.t array)];
  colors
;;

let factorial =
  lazy
    (let color_cardinality = force Color.cardinality in
     let results = Array.create ~len:(color_cardinality + 1) 1 in
     for i = 2 to color_cardinality do
       results.(i) <- i * results.(Int.pred i)
     done;
     results)
;;

let cardinality = lazy (force factorial).(force Color.cardinality)

let find_nth array ~n ~f =
  let rec aux k i =
    if i >= Array.length array
    then None
    else (
      let k = if f array.(i) then Int.succ k else k in
      if k >= n then Some i else aux k (Int.succ i))
  in
  aux (-1) 0
;;

let of_index_exn index =
  let color_cardinality = force Color.cardinality in
  let cardinality = force cardinality in
  let factorial = force factorial in
  if not (0 <= index && index < cardinality)
  then raise_s [%sexp "Index out of bounds", { index : int; cardinality : int }];
  let factorial_decomposition = Array.create ~len:color_cardinality 0 in
  let remainder = ref index in
  for i = color_cardinality - 1 downto 1 do
    factorial_decomposition.(i) <- !remainder / factorial.(i);
    remainder := !remainder % factorial.(i)
  done;
  let available_colors = Array.create ~len:color_cardinality true in
  let t = Array.create ~len:color_cardinality (Color.of_index_exn 0) in
  for i = 0 to color_cardinality - 1 do
    match
      find_nth
        available_colors
        ~n:factorial_decomposition.(color_cardinality - 1 - i)
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
            }] [@coverage off]
  done;
  t
;;

let to_index t =
  let color_cardinality = force Color.cardinality in
  let factorial = force factorial in
  let available_colors = Array.create ~len:color_cardinality true in
  let factorial_decomposition = Array.create ~len:color_cardinality 0 in
  for i = 0 to color_cardinality - 1 do
    let color = Color.to_index t.(i) in
    let count = ref 0 in
    for j = 0 to color - 1 do
      if available_colors.(j) then Int.incr count
    done;
    available_colors.(color) <- false;
    factorial_decomposition.(color_cardinality - 1 - i) <- !count
  done;
  Array.foldi factorial_decomposition ~init:0 ~f:(fun i acc d ->
    acc + (d * factorial.(i)))
;;

module Private = struct
  let find_nth = find_nth
end
