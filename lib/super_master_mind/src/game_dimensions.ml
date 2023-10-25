open! Base
open! Import

type t =
  { code_size : int
  ; num_colors : int
  }

let regular = { code_size = 5; num_colors = 8 }
let small_for_tests = { code_size = 3; num_colors = 4 }
let cell = ref None

let the_t here =
  match !cell with
  | Some (_, t) -> t
  | None ->
    cell := Some (here, regular);
    regular
;;

let use_small_game_dimensions_exn here =
  match !cell with
  | None -> cell := Some (here, small_for_tests)
  | Some (was_set_here, _) ->
    raise_s
      [%sexp
        "Game_dimensions is already set"
        , (here : Source_code_position.t)
        , { was_set_here : Source_code_position.t }]
;;

let param here =
  let open Command.Let_syntax in
  if%map_open
    flag
      "--use-small-game-dimensions"
      no_arg
      ~doc:" replace normal dimensions by smaller ones for quick tests"
  then use_small_game_dimensions_exn here
  else ()
;;

let code_size here =
  let t = the_t here in
  t.code_size
;;

let num_colors here =
  let t = the_t here in
  t.num_colors
;;
