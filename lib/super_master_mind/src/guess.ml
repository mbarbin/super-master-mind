open! Base
open! Import

module rec Next_best_guesses : sig
  (* When computed, best guesses are sorted by decreasing number of
     expected_bits_gained. *)
  type t =
    | Not_computed
    | Computed of T.t list
  [@@deriving equal, sexp]

  val is_computed : t -> bool
end = struct
  type t =
    | Not_computed
    | Computed of T.t list
  [@@deriving equal, sexp]

  let is_computed = function
    | Computed _ -> true
    | Not_computed -> false
  ;;
end

and By_cue : sig
  type t =
    { cue : Cue.t
    ; size_remaining : int
    ; bits_remaining : float
    ; bits_gained : float
    ; probability : float
    ; next_best_guesses : Next_best_guesses.t
    }
  [@@deriving equal, sexp]
end = struct
  type t =
    { cue : Cue.t
    ; size_remaining : int
    ; bits_remaining : float
    ; bits_gained : float
    ; probability : float
    ; next_best_guesses : Next_best_guesses.t
    }
  [@@deriving equal, sexp]
end

and T : sig
  type t =
    { candidate : Code.t
    ; expected_bits_gained : float
    ; expected_bits_remaining : float
    ; min_bits_gained : float
    ; max_bits_gained : float
    ; max_bits_remaining : float
    ; by_cue :
        By_cue.t Nonempty_list.t (* Sorted by decreasing number of remaining sizes *)
    }
  [@@deriving equal, sexp]
end = struct
  type t =
    { candidate : Code.t
    ; expected_bits_gained : float
    ; expected_bits_remaining : float
    ; min_bits_gained : float
    ; max_bits_gained : float
    ; max_bits_remaining : float
    ; by_cue : By_cue.t Nonempty_list.t
    }
  [@@deriving equal, sexp]
end

include T

let compute ~possible_solutions ~candidate : t =
  if Codes.is_empty possible_solutions
  then raise_s [%sexp "No possible solutions", [%here]];
  let original_size = Float.of_int (Codes.size possible_solutions) in
  let original_bits = Float.log2 original_size in
  let by_cue =
    let by_cue = Array.init (force Cue.cardinality) ~f:(fun _ -> Queue.create ()) in
    Codes.iter possible_solutions ~f:(fun solution ->
      let cue = Code.analyze ~solution ~candidate in
      Queue.enqueue by_cue.(Cue.to_index cue) solution);
    let by_cue =
      Array.filter_mapi by_cue ~f:(fun i remains ->
        let size_remaining = Queue.length remains in
        if size_remaining > 0
        then (
          let bits_remaining = Float.log2 (Float.of_int size_remaining) in
          Some
            { By_cue.cue = Cue.of_index_exn i
            ; size_remaining
            ; bits_remaining
            ; bits_gained = original_bits -. bits_remaining
            ; probability = Float.of_int size_remaining /. original_size
            ; next_best_guesses = Not_computed
            })
        else None)
    in
    Array.sort by_cue ~compare:(fun t1 t2 ->
      Int.compare t2.size_remaining t1.size_remaining);
    Nonempty_list.of_list_exn (Array.to_list by_cue)
  in
  let min_bits_gained =
    Nonempty_list.fold by_cue ~init:Float.infinity ~f:(fun acc t ->
      Float.min acc t.bits_gained)
  in
  let max_bits_gained =
    Nonempty_list.fold by_cue ~init:0. ~f:(fun acc t -> Float.max acc t.bits_gained)
  in
  let expected_bits_gained =
    Nonempty_list.fold by_cue ~init:0. ~f:(fun acc t ->
      acc +. (t.probability *. t.bits_gained))
  in
  let expected_bits_remaining = original_bits -. expected_bits_gained in
  { candidate
  ; expected_bits_gained
  ; expected_bits_remaining
  ; min_bits_gained
  ; max_bits_gained
  ; max_bits_remaining = original_bits -. min_bits_gained
  ; by_cue
  }
;;

let do_ansi f = if ANSITerminal.isatty.contents Core_unix.stdout then f ()

let compute_k_best ~task_pool ~possible_solutions ~k =
  if k < 1 then raise_s [%sexp "k >= 1 value expected", [%here], { k : int }];
  let ts =
    Kheap.create ~k ~compare:(fun (t1 : t) t2 ->
      let r = Float.compare t2.expected_bits_gained t1.expected_bits_gained in
      if r <> 0 then r else Code.compare t2.candidate t1.candidate)
  in
  let chan = Domainslib.Chan.make_unbounded () in
  let num_computed = ref 0 in
  let reduce () =
    let finished = ref false in
    while not !finished do
      match Domainslib.Chan.recv chan with
      | `Finished -> finished := true
      | `Computed (t : t) ->
        Int.incr num_computed;
        do_ansi (fun () ->
          ANSITerminal.move_bol ();
          ANSITerminal.print_string
            []
            (Printf.sprintf
               "Guess.compute_k_best : %d / %d"
               !num_computed
               (force Code.cardinality - 1)));
        if Float.( > ) t.expected_bits_gained 0. then Kheap.add ts t
    done
  in
  Task_pool.run task_pool ~f:(fun ~pool ->
    let reduced = Domainslib.Task.async pool reduce in
    Domainslib.Task.parallel_for
      pool
      ~start:0
      ~finish:(force Code.cardinality - 1)
      ~body:(fun candidate ->
        let t = compute ~possible_solutions ~candidate:(Code.of_index_exn candidate) in
        if Float.( > ) t.expected_bits_gained 0.
        then Domainslib.Chan.send chan (`Computed t));
    Domainslib.Chan.send chan `Finished;
    Domainslib.Task.await pool reduced);
  do_ansi (fun () ->
    ANSITerminal.move_bol ();
    ANSITerminal.erase Eol);
  Kheap.to_list ts
;;

let iter_or_error list ~f =
  let open Or_error.Let_syntax in
  let rec aux = function
    | [] -> return ()
    | hd :: tl ->
      let%bind () = f hd in
      aux tl
  in
  aux list
;;

let unexpected (type a) ~name ~(expected : a) ~(got : a) (sexp_of_a : a -> Sexp.t) =
  let diff =
    Sexp_diff.Algo.diff ~original:[%sexp (expected : a)] ~updated:[%sexp (got : a)] ()
  in
  let display =
    Sexp_diff.Display.display_as_plain_string
      (Sexp_diff.Display.Display_options.create ~num_shown:2 Two_column)
      diff
  in
  Or_error.error_s [%sexp ("Unexpected " ^ name : string), (display : string)]
;;

let rec verify (t : t) ~possible_solutions =
  let open Or_error.Let_syntax in
  let t' = compute ~possible_solutions ~candidate:t.candidate in
  match Nonempty_list.zip t.by_cue t'.by_cue with
  | Unequal_lengths ->
    unexpected
      ~name:"by_cue length"
      ~expected:(Nonempty_list.length t'.by_cue)
      ~got:(Nonempty_list.length t.by_cue)
      [%sexp_of: int]
  | Ok by_cues ->
    let%bind () =
      let t = { t with by_cue = t'.by_cue } in
      if equal t t'
      then return ()
      else unexpected ~name:"values" ~expected:t' ~got:t [%sexp_of: t]
    in
    iter_or_error (Nonempty_list.to_list by_cues) ~f:(fun (by_cue, by_cue') ->
      assert (not (Next_best_guesses.is_computed by_cue'.next_best_guesses));
      let%bind () =
        let by_cue = { by_cue with next_best_guesses = Not_computed } in
        if By_cue.equal by_cue' by_cue
        then return ()
        else unexpected ~name:"by_cue" ~expected:by_cue' ~got:by_cue [%sexp_of: By_cue.t]
      in
      match by_cue.next_best_guesses with
      | Not_computed -> return ()
      | Computed ts ->
        let possible_solutions =
          Codes.filter possible_solutions ~candidate:t.candidate ~cue:by_cue.cue
        in
        iter_or_error ts ~f:(fun t -> verify t ~possible_solutions))
;;

let map_color t ~color_permutation =
  let rec aux_t
    { candidate : Code.t
    ; expected_bits_gained : float
    ; expected_bits_remaining : float
    ; min_bits_gained : float
    ; max_bits_gained : float
    ; max_bits_remaining : float
    ; by_cue : By_cue.t Nonempty_list.t
    }
    =
    { candidate = Code.map_color candidate ~color_permutation
    ; expected_bits_gained : float
    ; expected_bits_remaining : float
    ; min_bits_gained : float
    ; max_bits_gained : float
    ; max_bits_remaining : float
    ; by_cue = Nonempty_list.map by_cue ~f:aux_by_cue
    }
  and aux_by_cue
    { By_cue.cue : Cue.t
    ; size_remaining : int
    ; bits_remaining : float
    ; bits_gained : float
    ; probability : float
    ; next_best_guesses : Next_best_guesses.t
    }
    =
    { By_cue.cue : Cue.t
    ; size_remaining : int
    ; bits_remaining : float
    ; bits_gained : float
    ; probability : float
    ; next_best_guesses = aux_next_best_guesses next_best_guesses
    }
  and aux_next_best_guesses : Next_best_guesses.t -> Next_best_guesses.t = function
    | Not_computed -> Not_computed
    | Computed ts -> Computed (List.map ts ~f:aux_t)
  in
  aux_t t
;;
