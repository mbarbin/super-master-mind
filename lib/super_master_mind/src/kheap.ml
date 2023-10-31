module Node = struct
  type 'a t =
    { value : 'a
    ; mutable tail : 'a t option
    }
end

type 'a t =
  { k : int
  ; compare : 'a -> 'a -> int
  ; mutable head : 'a Node.t option
  }

let create ~k ~compare =
  assert (k > 0);
  { k; compare; head = None }
;;

let to_list t =
  let q = Queue.create () in
  let rec aux = function
    | None -> ()
    | Some (t : _ Node.t) ->
      Queue.enqueue q t.value;
      aux t.tail
  in
  aux t.head;
  Queue.to_list q
;;

let sexp_of_t sexp_of_a t = [%sexp (to_list t : a list)]

let rec cut node ~k =
  match node with
  | None -> None
  | Some ({ Node.value = _; tail } as t) ->
    if k = 0
    then None
    else (
      t.tail <- cut tail ~k:(Int.pred k);
      node)
;;

let add t a =
  let rec aux k = function
    | None -> if k >= 1 then Some { Node.value = a; tail = None } else None
    | Some (node : _ Node.t) as head ->
      (match Ordering.of_int (t.compare node.value a) with
       | Greater ->
         (* Insert [a] before [node.value]. *)
         let tail = cut head ~k:(Int.pred k) in
         Some { Node.value = a; tail }
       | Equal | Less ->
         (* Insert [a] after [node.value]. *)
         node.tail <- aux (Int.pred k) node.tail;
         head)
  in
  t.head <- aux t.k t.head
;;
