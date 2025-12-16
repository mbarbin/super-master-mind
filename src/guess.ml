(*********************************************************************************)
(*  super-master-mind: A solver for the super master mind game                   *)
(*  SPDX-FileCopyrightText: 2021-2025 Mathieu Barbin <mathieu.barbin@gmail.com>  *)
(*  SPDX-License-Identifier: MIT                                                 *)
(*********************************************************************************)

module rec Next_best_guesses : sig
  type t =
    | Not_computed
    | Computed of T.t list

  val equal : t -> t -> bool
  val is_computed : t -> bool
  val to_dyn : t -> Dyn.t
  val to_json_opt : t -> Json.t option
  val of_json_opt : Json.t option -> t
end = struct
  type t =
    | Not_computed
    | Computed of T.t list

  let equal t1 = function
    | Not_computed ->
      (match t1 with
       | Not_computed -> true
       | Computed _ -> false)
    | Computed list2 ->
      (match t1 with
       | Not_computed -> false
       | Computed list1 -> List.equal T.equal list1 list2)
  ;;

  let is_computed = function
    | Computed _ -> true
    | Not_computed -> false
  ;;

  let to_dyn = function
    | Not_computed -> Dyn.variant "Not_computed" []
    | Computed ts -> Dyn.variant "Computed" [ Dyn.list T.to_dyn ts ]
  ;;

  let to_json_opt (t : t) : Json.t option =
    match t with
    | Not_computed -> None
    | Computed ts -> Some (`List (List.map ts ~f:T.to_json))
  ;;

  let of_json_opt (json : Json.t option) : t =
    match json with
    | None -> Not_computed
    | Some (`List items) -> Computed (List.map items ~f:T.of_json)
    | Some json ->
      raise (Json.Invalid_json ("Expected list for [Next_best_guesses.t].", json))
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

  val equal : t -> t -> bool
  val to_dyn : t -> Dyn.t
  val to_json : t -> Json.t
  val of_json : Json.t -> t
end = struct
  type t =
    { cue : Cue.t
    ; size_remaining : int
    ; bits_remaining : float
    ; bits_gained : float
    ; probability : float
    ; next_best_guesses : Next_best_guesses.t
    }

  let equal
        t
        ({ cue
         ; size_remaining
         ; bits_remaining
         ; bits_gained
         ; probability
         ; next_best_guesses
         } as t2)
    =
    phys_equal t t2
    || (Cue.equal t.cue cue
        && Int.equal t.size_remaining size_remaining
        && Float.equal t.bits_remaining bits_remaining
        && Float.equal t.bits_gained bits_gained
        && Float.equal t.probability probability
        && Next_best_guesses.equal t.next_best_guesses next_best_guesses)
  ;;

  let to_dyn
        { cue
        ; size_remaining
        ; bits_remaining
        ; bits_gained
        ; probability
        ; next_best_guesses
        }
    =
    Dyn.record
      [ "cue", Cue.to_dyn cue
      ; "size_remaining", Dyn.int size_remaining
      ; "bits_remaining", Dyn.float bits_remaining
      ; "bits_gained", Dyn.float bits_gained
      ; "probability", Dyn.float probability
      ; "next_best_guesses", Next_best_guesses.to_dyn next_best_guesses
      ]
  ;;

  let to_json
        { cue
        ; size_remaining
        ; bits_remaining
        ; bits_gained
        ; probability
        ; next_best_guesses
        }
    : Json.t
    =
    let base =
      [ "cue", Cue.to_json cue
      ; "size_remaining", `Int size_remaining
      ; "bits_remaining", `Float bits_remaining
      ; "bits_gained", `Float bits_gained
      ; "probability", `Float probability
      ]
    in
    let fields =
      match Next_best_guesses.to_json_opt next_best_guesses with
      | None -> base
      | Some json -> base @ [ "next_best_guesses", json ]
    in
    `Assoc fields
  ;;

  let of_json (json : Json.t) : t =
    match json with
    | `Assoc fields ->
      let cue_ref = ref None in
      let size_remaining_ref = ref None in
      let bits_remaining_ref = ref None in
      let bits_gained_ref = ref None in
      let probability_ref = ref None in
      let next_best_guesses_ref = ref None in
      List.iter fields ~f:(fun (name, value) ->
        match name with
        | "cue" -> cue_ref := Some (Cue.of_json value)
        | "size_remaining" ->
          size_remaining_ref
          := Some
               (match value with
                | `Int i -> i
                | _ ->
                  raise (Json.Invalid_json ("Expected int for [size_remaining].", value)))
        | "bits_remaining" ->
          bits_remaining_ref
          := Some
               (match value with
                | `Float f -> f
                | `Int i -> Float.of_int i
                | _ ->
                  raise
                    (Json.Invalid_json ("Expected float for [bits_remaining].", value)))
        | "bits_gained" ->
          bits_gained_ref
          := Some
               (match value with
                | `Float f -> f
                | `Int i -> Float.of_int i
                | _ ->
                  raise (Json.Invalid_json ("Expected float for [bits_gained].", value)))
        | "probability" ->
          probability_ref
          := Some
               (match value with
                | `Float f -> f
                | `Int i -> Float.of_int i
                | _ ->
                  raise (Json.Invalid_json ("Expected float for [probability].", value)))
        | "next_best_guesses" -> next_best_guesses_ref := Some value
        | _ -> ());
      let require ref_val field_name =
        match !ref_val with
        | Some v -> v
        | None ->
          raise
            (Json.Invalid_json (Printf.sprintf "Missing field [%s]." field_name, json))
      in
      { cue = require cue_ref "cue"
      ; size_remaining = require size_remaining_ref "size_remaining"
      ; bits_remaining = require bits_remaining_ref "bits_remaining"
      ; bits_gained = require bits_gained_ref "bits_gained"
      ; probability = require probability_ref "probability"
      ; next_best_guesses = Next_best_guesses.of_json_opt !next_best_guesses_ref
      }
    | _ -> raise (Json.Invalid_json ("Expected JSON object for [By_cue.t].", json))
  ;;
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

  val equal : t -> t -> bool
  val to_dyn : t -> Dyn.t
  val to_json : t -> Json.t
  val of_json : Json.t -> t
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

  let equal
        t
        ({ candidate
         ; expected_bits_gained
         ; expected_bits_remaining
         ; min_bits_gained
         ; max_bits_gained
         ; max_bits_remaining
         ; by_cue
         } as t2)
    =
    phys_equal t t2
    || (Code.equal t.candidate candidate
        && Float.equal t.expected_bits_gained expected_bits_gained
        && Float.equal t.expected_bits_remaining expected_bits_remaining
        && Float.equal t.min_bits_gained min_bits_gained
        && Float.equal t.max_bits_gained max_bits_gained
        && Float.equal t.max_bits_remaining max_bits_remaining
        && Nonempty_list.equal By_cue.equal t.by_cue by_cue)
  ;;

  let to_dyn
        { candidate
        ; expected_bits_gained
        ; expected_bits_remaining
        ; min_bits_gained
        ; max_bits_gained
        ; max_bits_remaining
        ; by_cue
        }
    =
    Dyn.record
      [ "candidate", Code.to_dyn candidate
      ; "expected_bits_gained", Dyn.float expected_bits_gained
      ; "expected_bits_remaining", Dyn.float expected_bits_remaining
      ; "min_bits_gained", Dyn.float min_bits_gained
      ; "max_bits_gained", Dyn.float max_bits_gained
      ; "max_bits_remaining", Dyn.float max_bits_remaining
      ; "by_cue", Dyn.list By_cue.to_dyn (Nonempty_list.to_list by_cue)
      ]
  ;;

  let to_json
        { candidate
        ; expected_bits_gained
        ; expected_bits_remaining
        ; min_bits_gained
        ; max_bits_gained
        ; max_bits_remaining
        ; by_cue
        }
    : Json.t
    =
    `Assoc
      [ "candidate", Code.to_json candidate
      ; "expected_bits_gained", `Float expected_bits_gained
      ; "expected_bits_remaining", `Float expected_bits_remaining
      ; "min_bits_gained", `Float min_bits_gained
      ; "max_bits_gained", `Float max_bits_gained
      ; "max_bits_remaining", `Float max_bits_remaining
      ; "by_cue", `List (List.map (Nonempty_list.to_list by_cue) ~f:By_cue.to_json)
      ]
  ;;

  let of_json (json : Json.t) : t =
    match json with
    | `Assoc fields ->
      let candidate_ref = ref None in
      let expected_bits_gained_ref = ref None in
      let expected_bits_remaining_ref = ref None in
      let min_bits_gained_ref = ref None in
      let max_bits_gained_ref = ref None in
      let max_bits_remaining_ref = ref None in
      let by_cue_ref = ref None in
      List.iter fields ~f:(fun (name, value) ->
        match name with
        | "candidate" -> candidate_ref := Some (Code.of_json value)
        | "expected_bits_gained" ->
          expected_bits_gained_ref
          := Some
               (match value with
                | `Float f -> f
                | `Int i -> Float.of_int i
                | _ ->
                  raise
                    (Json.Invalid_json
                       ("Expected float for [expected_bits_gained].", value)))
        | "expected_bits_remaining" ->
          expected_bits_remaining_ref
          := Some
               (match value with
                | `Float f -> f
                | `Int i -> Float.of_int i
                | _ ->
                  raise
                    (Json.Invalid_json
                       ("Expected float for [expected_bits_remaining].", value)))
        | "min_bits_gained" ->
          min_bits_gained_ref
          := Some
               (match value with
                | `Float f -> f
                | `Int i -> Float.of_int i
                | _ ->
                  raise
                    (Json.Invalid_json ("Expected float for [min_bits_gained].", value)))
        | "max_bits_gained" ->
          max_bits_gained_ref
          := Some
               (match value with
                | `Float f -> f
                | `Int i -> Float.of_int i
                | _ ->
                  raise
                    (Json.Invalid_json ("Expected float for [max_bits_gained].", value)))
        | "max_bits_remaining" ->
          max_bits_remaining_ref
          := Some
               (match value with
                | `Float f -> f
                | `Int i -> Float.of_int i
                | _ ->
                  raise
                    (Json.Invalid_json ("Expected float for [max_bits_remaining].", value)))
        | "by_cue" ->
          by_cue_ref
          := Some
               (match value with
                | `List items -> List.map items ~f:By_cue.of_json
                | _ -> raise (Json.Invalid_json ("Expected list for [by_cue].", value)))
        | _ -> ());
      let require ref_val field_name =
        match !ref_val with
        | Some v -> v
        | None ->
          raise
            (Json.Invalid_json (Printf.sprintf "Missing field [%s]." field_name, json))
      in
      { candidate = require candidate_ref "candidate"
      ; expected_bits_gained = require expected_bits_gained_ref "expected_bits_gained"
      ; expected_bits_remaining =
          require expected_bits_remaining_ref "expected_bits_remaining"
      ; min_bits_gained = require min_bits_gained_ref "min_bits_gained"
      ; max_bits_gained = require max_bits_gained_ref "max_bits_gained"
      ; max_bits_remaining = require max_bits_remaining_ref "max_bits_remaining"
      ; by_cue = Nonempty_list.of_list_exn (require by_cue_ref "by_cue")
      }
    | _ -> raise (Json.Invalid_json ("Expected JSON object for [Guess.t].", json))
  ;;
end

include T

let to_json = T.to_json
let of_json = T.of_json

(* Truncate log2 results to 10 decimal places for cross-platform determinism.
   Different libm implementations (glibc vs Apple's) can produce results differing
   at the 15th-16th significant digit. 10 decimal places provides far more precision
   than needed for entropy calculations while ensuring reproducible results. *)
let log2_truncated x = Float.round (Float.log2 x *. 1e10) /. 1e10

let compute ~possible_solutions ~candidate : t =
  if Codes.is_empty possible_solutions then Code_error.raise "No possible solutions." [];
  let original_size = Float.of_int (Codes.size possible_solutions) in
  let original_bits = log2_truncated original_size in
  let by_cue =
    let by_cue = Array.init (Lazy.force Cue.cardinality) ~f:(fun _ -> []) in
    Codes.iter possible_solutions ~f:(fun solution ->
      let cue = Code.analyze ~solution ~candidate in
      let index = Cue.to_index cue in
      by_cue.(index) <- solution :: by_cue.(index));
    let by_cue =
      Array.filter_mapi by_cue ~f:(fun i remains ->
        let size_remaining = List.length remains in
        if size_remaining > 0
        then (
          let bits_remaining = log2_truncated (Float.of_int size_remaining) in
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
      match Int.compare t2.size_remaining t1.size_remaining with
      | (Lt | Gt) as res -> res
      | Eq -> Cue.compare t1.cue t2.cue);
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
  if k < 1 then Code_error.raise "k >= 1 value expected." [ "k", Dyn.int k ];
  let ts =
    Kheap.create ~k ~compare:(fun (t1 : t) t2 ->
      match Float.compare t2.expected_bits_gained t1.expected_bits_gained with
      | (Lt | Gt) as res -> res
      | Eq -> Code.compare t2.candidate t1.candidate)
  in
  let chan = Domainslib.Chan.make_unbounded () in
  let bar =
    let total = Lazy.force Code.cardinality in
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
        (match Float.compare t.expected_bits_gained 0. with
         | Lt | Eq -> ()
         | Gt -> Kheap.add ts t)
    done
  in
  Task_pool.run task_pool ~f:(fun ~pool ->
    let reduced = Domainslib.Task.async pool reduce in
    Domainslib.Task.parallel_for
      pool
      ~start:0
      ~finish:(Lazy.force Code.cardinality - 1)
      ~body:(fun candidate ->
        let t = compute ~possible_solutions ~candidate:(Code.of_index_exn candidate) in
        match Float.compare t.expected_bits_gained 0. with
        | Lt | Eq -> ()
        | Gt -> Domainslib.Chan.send chan (`Computed t));
    Domainslib.Chan.send chan `Finished;
    Domainslib.Task.await pool reduced);
  Progress.Reporter.finalise reporter;
  Option.iter display ~f:(fun display -> Progress.Display.remove_line display reporter);
  Option.iter local_display ~f:Progress.Display.finalise;
  Kheap.to_list ts
;;

let rec iter_result list ~f =
  match list with
  | [] -> Ok ()
  | hd :: tl ->
    (match f hd with
     | Ok () -> iter_result tl ~f
     | Error _ as err -> err)
;;

module Verify_error = struct
  type t =
    { unexpected_field : string
    ; expected : Dyn.t
    ; computed : Dyn.t
    }

  let diff ~expected ~computed =
    Expect_test_patdiff.patdiff
      (Dyn.to_string expected)
      (Dyn.to_string computed)
      ~context:3
  ;;

  let to_dyn { unexpected_field; expected; computed } =
    let diff = diff ~expected ~computed in
    Dyn.record
      [ "unexpected_field", Dyn.string unexpected_field; "diff", Dyn.string diff ]
  ;;

  let print_hum { unexpected_field; expected; computed } oc =
    Out_channel.output_lines
      oc
      [ Printf.sprintf "Unexpected %s:" unexpected_field; diff ~expected ~computed ]
  ;;
end

let unexpected
      (type a)
      ~unexpected_field
      ~(expected : a)
      ~(computed : a)
      (to_dyn_a : a -> Dyn.t)
  =
  Error
    { Verify_error.unexpected_field
    ; expected = expected |> to_dyn_a
    ; computed = computed |> to_dyn_a
    }
;;

let rec verify (t : t) ~possible_solutions =
  let ( let* ) x f = Result.bind x ~f in
  let t' = compute ~possible_solutions ~candidate:t.candidate in
  match Nonempty_list.zip t.by_cue t'.by_cue with
  | Unequal_lengths ->
    unexpected
      ~unexpected_field:"by_cue length"
      ~expected:(Nonempty_list.length t'.by_cue)
      ~computed:(Nonempty_list.length t.by_cue)
      Dyn.int
  | Ok by_cues ->
    let* () =
      let t = { t with by_cue = t'.by_cue } in
      if equal t t'
      then Ok ()
      else unexpected ~unexpected_field:"values" ~expected:t' ~computed:t to_dyn
    in
    iter_result (Nonempty_list.to_list by_cues) ~f:(fun (by_cue, by_cue') ->
      assert (not (Next_best_guesses.is_computed by_cue'.next_best_guesses));
      let* () =
        let by_cue = { by_cue with next_best_guesses = Not_computed } in
        if By_cue.equal by_cue' by_cue
        then Ok ()
        else
          unexpected
            ~unexpected_field:"by_cue"
            ~expected:by_cue'
            ~computed:by_cue
            By_cue.to_dyn
      in
      match by_cue.next_best_guesses with
      | Not_computed -> Ok ()
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
