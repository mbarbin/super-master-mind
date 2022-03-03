open! Core
open! Import

type t = Permutation.t Queue.t [@@deriving sexp_of]

let iter = Queue.iter
let to_list = Queue.to_list
let size = Queue.length

let all =
  lazy
    (let t = Queue.create () in
     let rec aux i =
       if i < Permutation.cardinality
       then (
         Queue.enqueue t (Permutation.of_index_exn i);
         aux (succ i))
     in
     aux 0;
     t)
;;

let filter t ~cache ~candidate ~cue =
  let t' = Queue.create () in
  Queue.iter t ~f:(fun solution ->
      if Cue.equal cue (Permutation.analyse ~cache ~solution ~candidate)
      then Queue.enqueue t' solution);
  t'
;;

let bits t = Float.log2 (Float.of_int (size t))
