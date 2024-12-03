module rec Next_best_guesses : sig
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

let compute_k_best ?display ~task_pool ~possible_solutions ~k () =
  if k < 1 then raise_s [%sexp "k >= 1 value expected", [%here], { k : int }];
  let ts =
    Kheap.create ~k ~compare:(fun (t1 : t) t2 ->
      let r = Float.compare t2.expected_bits_gained t1.expected_bits_gained in
      if r <> 0 then r else Code.compare t2.candidate t1.candidate)
  in
  let chan = Domainslib.Chan.make_unbounded () in
  let bar =
    let total = force Code.cardinality in
    let open Progress.Line in
    list [ bar total; count_to total; parens (const "eta: " ++ eta total) ]
  in
  let reporter, local_display =
    match display with
    | Some display -> Progress.Display.add_line display bar, None
    | None ->
      let display =
        Progress.Display.start
          ~config:(Progress.Config.v ~persistent:false ())
          (Progress.Multi.line bar)
      in
      Progress.Display.add_line display bar, Some display
  in
  let reduce () =
    let finished = ref false in
    while not !finished do
      match Domainslib.Chan.recv chan with
      | `Finished -> finished := true
      | `Computed (t : t) ->
        Progress.Reporter.report reporter 1;
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
  Progress.Reporter.finalise reporter;
  Option.iter display ~f:(fun display -> Progress.Display.remove_line display reporter);
  Option.iter local_display ~f:Progress.Display.finalise;
  Kheap.to_list ts
;;

let iter_result list ~f = List.fold_result list ~init:() ~f:(fun () a -> f a)

module Verify_error = struct
  type t =
    { unexpected_field : string
    ; expected : Sexp.t
    ; computed : Sexp.t
    }

  let to_error { unexpected_field; expected; computed } =
    let diff =
      Expect_test_patdiff.patdiff_s expected computed ~context:3 |> String.split_lines
    in
    Error.create_s [%sexp { unexpected_field : string; diff : string list }]
  ;;

  let print_hum ?(color = false) { unexpected_field; expected; computed } oc =
    let diff =
      if color
      then
        Patdiff.Patdiff_core.patdiff
          ~prev:{ name = "expected"; text = Sexp.to_string_hum expected }
          ~next:{ name = "computed"; text = Sexp.to_string_hum computed }
          () [@coverage off]
      else Expect_test_patdiff.patdiff_s expected computed ~context:3
    in
    Out_channel.output_lines oc [ Printf.sprintf "Unexpected %s:" unexpected_field; diff ]
  ;;
end

let unexpected
      (type a)
      ~unexpected_field
      ~(expected : a)
      ~(computed : a)
      (sexp_of_a : a -> Sexp.t)
  =
  Error
    { Verify_error.unexpected_field
    ; expected = [%sexp (expected : a)]
    ; computed = [%sexp (computed : a)]
    }
;;

let rec verify (t : t) ~possible_solutions =
  let open Result.Let_syntax in
  let t' = compute ~possible_solutions ~candidate:t.candidate in
  match Nonempty_list.zip t.by_cue t'.by_cue with
  | Unequal_lengths ->
    unexpected
      ~unexpected_field:"by_cue length"
      ~expected:(Nonempty_list.length t'.by_cue)
      ~computed:(Nonempty_list.length t.by_cue)
      [%sexp_of: int]
  | Ok by_cues ->
    let%bind () =
      let t = { t with by_cue = t'.by_cue } in
      if equal t t'
      then return ()
      else unexpected ~unexpected_field:"values" ~expected:t' ~computed:t [%sexp_of: t]
    in
    iter_result (Nonempty_list.to_list by_cues) ~f:(fun (by_cue, by_cue') ->
      assert (not (Next_best_guesses.is_computed by_cue'.next_best_guesses));
      let%bind () =
        let by_cue = { by_cue with next_best_guesses = Not_computed } in
        if By_cue.equal by_cue' by_cue
        then return ()
        else
          unexpected
            ~unexpected_field:"by_cue"
            ~expected:by_cue'
            ~computed:by_cue
            [%sexp_of: By_cue.t]
      in
      match by_cue.next_best_guesses with
      | Not_computed -> return ()
      | Computed ts ->
        let possible_solutions =
          Codes.filter possible_solutions ~candidate:t.candidate ~cue:by_cue.cue
        in
        iter_result ts ~f:(fun t -> verify t ~possible_solutions))
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
