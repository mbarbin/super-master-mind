(*********************************************************************************)
(*  super-master-mind: A solver for the super master mind game                   *)
(*  SPDX-FileCopyrightText: 2021-2025 Mathieu Barbin <mathieu.barbin@gmail.com>  *)
(*  SPDX-License-Identifier: MIT                                                 *)
(*********************************************************************************)

type t = Color.t array

let equal t1 t2 = Array.equal Color.equal t1 t2

let compare t1 t2 =
  let s1 = Array.length t1
  and s2 = Array.length t2 in
  let res = Int.compare s1 s2 in
  if res <> 0
  then res
  else
    let exception Stop of int in
    try
      Array.iter2 t1 t2 ~f:(fun x y ->
        let res = Color.compare x y in
        if res <> 0 then Stdlib.raise_notrace (Stop res));
      0
    with
    | Stop res -> res
;;

let to_dyn t = Dyn.array Color.to_dyn t
let identity = lazy (Array.init (force Color.cardinality) ~f:Color.of_index_exn)
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
  then
    Code_error.raise
      "Invalid color permutation."
      [ "hums", Dyn.array Color.Hum.to_dyn hums ];
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

let is_valid_index ~index =
  let cardinality = force cardinality in
  0 <= index && index < cardinality
;;

let of_index_exn index =
  let color_cardinality = force Color.cardinality in
  let cardinality = force cardinality in
  let factorial = force factorial in
  if not (is_valid_index ~index)
  then
    Code_error.raise
      "Index out of bounds."
      [ "index", Dyn.int index; "cardinality", Dyn.int cardinality ];
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
      Code_error.raise
        "Unexpected decomposition."
        [ "index", Dyn.int index
        ; "factorial_decomposition", Dyn.array Dyn.int factorial_decomposition
        ; "available_colors", Dyn.array Dyn.bool available_colors
        ; "t", to_dyn t
        ] [@coverage off]
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

let param =
  Command.Param.create'
    ~docv:"COLOR_PERMUTATION"
    ~of_string:(fun i ->
      match Int.of_string i with
      | exception _ -> Error (`Msg "Invalid color permutation")
      | index ->
        if is_valid_index ~index
        then Ok (of_index_exn index)
        else Error (`Msg "Invalid color permutation"))
    ~to_string:(fun t -> Int.to_string (to_index t))
    ()
;;

module Private = struct
  let find_nth = find_nth
end
