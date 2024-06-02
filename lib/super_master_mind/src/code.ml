type t = int [@@deriving compare, equal, hash]

let size = Cue.code_size
let cardinality = lazy (Int.pow (force Color.cardinality) (force size))

module Hum = struct
  type t = Color.Hum.t array [@@deriving sexp]
end

module Computing = struct
  type t = Color.t array

  let check_size_exn hum =
    let expected_size = force size in
    let code_size = Array.length hum in
    if code_size <> expected_size
    then
      raise_s
        [%sexp
          "Invalid code size"
          , { code = (hum : Hum.t); code_size : int; expected_size : int }]
  ;;

  let create_exn hum =
    check_size_exn hum;
    Array.map hum ~f:Color.of_hum
  ;;

  let to_hum t = t |> Array.map ~f:Color.to_hum

  let of_code (i : int) : t =
    let size = force size in
    let color_cardinality = force Color.cardinality in
    let colors = Array.create ~len:size (Color.of_index_exn 0) in
    let remainder = ref i in
    for i = 0 to size - 1 do
      let rem = !remainder % color_cardinality in
      remainder := !remainder / color_cardinality;
      colors.(i) <- Color.of_index_exn rem
    done;
    colors
  ;;

  let to_code (t : t) : int =
    let color_cardinality = force Color.cardinality in
    Array.fold_right t ~init:0 ~f:(fun color acc ->
      (acc * color_cardinality) + Color.to_index color)
  ;;

  let analyze ~(solution : t) ~(candidate : t) =
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
          Int.incr black;
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
          Int.incr white;
          solution.(j) <- None));
    Cue.create_exn { white = !white; black = !black }
  ;;

  let map_color t ~color_permutation =
    Array.map t ~f:(fun color -> Color_permutation.map_color color_permutation color)
  ;;
end

let create_exn hum = hum |> Computing.create_exn |> Computing.to_code
let to_hum t = t |> Computing.of_code |> Computing.to_hum
let sexp_of_t t = [%sexp (to_hum t : Hum.t)]
let t_of_sexp sexp = sexp |> [%of_sexp: Hum.t] |> create_exn
let to_index t = t

let check_index_exn index =
  let cardinality = force cardinality in
  if not (0 <= index && index < cardinality)
  then raise_s [%sexp "Index out of bounds", { index : int; cardinality : int }]
;;

let of_index_exn index =
  check_index_exn index;
  index
;;

let analyze ~solution ~candidate =
  Computing.analyze
    ~solution:(Computing.of_code solution)
    ~candidate:(Computing.of_code candidate)
;;

let map_color t ~color_permutation =
  t |> Computing.of_code |> Computing.map_color ~color_permutation |> Computing.to_code
;;
