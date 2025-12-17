(*********************************************************************************)
(*  super-master-mind: A solver for the super master mind game                   *)
(*  SPDX-FileCopyrightText: 2021-2025 Mathieu Barbin <mathieu.barbin@gmail.com>  *)
(*  SPDX-License-Identifier: MIT                                                 *)
(*********************************************************************************)

type t = int

let equal = Int.equal
let compare = Int.compare
let size = Cue.code_size

let cardinality =
  lazy
    (let cardinality = Lazy.force Color.cardinality in
     let size = Lazy.force size in
     let res = ref cardinality in
     for _ = 2 to size do
       res := !res * cardinality
     done;
     !res)
;;

module Hum = struct
  type t = Color.Hum.t array

  let to_dyn t = Dyn.array Color.Hum.to_dyn t
  let to_json t : Json.t = `List (Array.to_list t |> List.map ~f:Color.Hum.to_json)

  let of_json (json : Json.t) : t =
    match json with
    | `List l -> Array.of_list l |> Array.map ~f:Color.Hum.of_json
    | _ -> raise (Json.Invalid_json ("Expected list for [Code.Hum.t].", json))
  ;;

  let to_string t = to_json t |> Json.to_string
end

module Computing = struct
  type t = Color.t array

  let check_size_exn hum =
    let expected_size = Lazy.force size in
    let code_size = Array.length hum in
    if code_size <> expected_size
    then
      Code_error.raise
        "Invalid code size."
        [ "code", Hum.to_dyn hum
        ; "code_size", Dyn.int code_size
        ; "expected_size", Dyn.int expected_size
        ]
  ;;

  let create_exn hum =
    check_size_exn hum;
    Array.map hum ~f:Color.of_hum
  ;;

  let to_hum t = t |> Array.map ~f:Color.to_hum

  let of_code (i : int) : t =
    let size = Lazy.force size in
    let color_cardinality = Lazy.force Color.cardinality in
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
    let color_cardinality = Lazy.force Color.cardinality in
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
let to_dyn t = t |> to_hum |> Hum.to_dyn
let to_index t = t
let of_json_hum json = Hum.of_json json |> create_exn

let param =
  Command.Param.create'
    ~docv:"CODE"
    ~of_string:(fun s ->
      match Json.of_string s |> of_json_hum with
      | e -> Ok e
      | exception e -> Error (`Msg (Exn.to_string e)))
    ~to_string:(fun t -> Hum.to_string (to_hum t))
    ()
;;

let check_index_exn index =
  let cardinality = Lazy.force cardinality in
  if not (0 <= index && index < cardinality)
  then
    Code_error.raise
      "Index out of bounds."
      [ "index", Dyn.int index; "cardinality", Dyn.int cardinality ]
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

let to_json t : Json.t = `Int (to_index t)

let of_json (json : Json.t) : t =
  match json with
  | `Int i -> of_index_exn i
  | _ -> raise (Json.Invalid_json ("Expected int for [Code.t].", json))
;;
