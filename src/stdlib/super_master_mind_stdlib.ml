(*********************************************************************************)
(*  super-master-mind: A solver for the super master mind game                   *)
(*  SPDX-FileCopyrightText: 2021-2025 Mathieu Barbin <mathieu.barbin@gmail.com>  *)
(*  SPDX-License-Identifier: MIT                                                 *)
(*********************************************************************************)

module Code_error = Code_error
module Dyn = Dyn0
module Json = Json
module Ordering = Ordering
module Source_code_position = Source_code_position

let print pp = Format.printf "%a@." Pp.to_fmt pp
let print_dyn dyn = print (Dyn.pp dyn)
let phys_equal (type a) (x : a) (y : a) = x == y

let require cond =
  if not cond then Code_error.raise "Required condition does not hold." []
;;

let require_does_raise f =
  match f () with
  | _ -> Code_error.raise "Did not raise." []
  | exception e -> print_endline (Printexc.to_string e)
;;

module Array = struct
  include Stdlib.ArrayLabels

  let equal eq t1 t2 =
    phys_equal t1 t2 || (Array.length t1 = Array.length t2 && Array.for_all2 eq t1 t2)
  ;;

  let is_empty t = Array.length t = 0
  let create ~len a = Array.make len a

  let filter_mapi t ~f =
    t |> Array.to_seqi |> Seq.filter_map (fun (i, x) -> f i x) |> Array.of_seq
  ;;

  let fold t ~init ~f = fold_left t ~init ~f

  let foldi t ~init ~f =
    t |> Array.to_seqi |> Seq.fold_left (fun acc (i, e) -> f i acc e) init
  ;;

  let sort t ~compare = sort t ~cmp:compare
end

module Hashtbl = struct
  include MoreLabels.Hashtbl

  let set t ~key ~data = replace t ~key ~data
end

module In_channel = struct
  include Stdlib.In_channel

  let read_all file = with_open_bin file input_all
end

module Int = struct
  include Stdlib.Int

  let incr = incr
  let of_string = int_of_string_opt
end

module List = struct
  include Stdlib.ListLabels

  let rec drop_while li ~f =
    match li with
    | x :: l when f x -> drop_while l ~f
    | rest -> rest
  ;;

  let equal eq t1 t2 = equal ~eq t1 t2

  let is_empty = function
    | [] -> true
    | _ :: _ -> false
  ;;

  let iter t ~f = iter ~f t
  let fold t ~init ~f = fold_left t ~init ~f
end

module Option = struct
  include Stdlib.Option

  let bind x ~f = bind x f
  let iter t ~f = iter f t
  let some_if cond a = if cond then Some a else None
end

module Out_channel = struct
  include Stdlib.Out_channel

  let output_lines t lines =
    List.iter lines ~f:(fun line ->
      output_string t line;
      output_char t '\n')
  ;;

  let with_open_text t ~f = with_open_text t f
end

module Result = struct
  include Stdlib.Result

  let bind x ~f = bind x f
  let map_error t ~f = map_error f t
end

module String = struct
  include Stdlib.StringLabels

  let concat ts ~sep = concat ~sep ts
  let split t ~on = split_on_char ~sep:on t
end
