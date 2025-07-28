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

let normalize_fname (p : Source_code_position.t) =
  let aux f =
    let parts = String.split f ~on:'/' in
    List.drop_while parts ~f:(fun part -> not (String.equal part "lib"))
    |> String.concat ~sep:"/"
  in
  { p with pos_fname = aux p.pos_fname }
;;

let use_small_game_dimensions_exn here =
  match !cell with
  | None -> cell := Some (here, small_for_tests)
  | Some (was_set_here, _) ->
    raise_s
      [%sexp
        "Game_dimensions is already set"
      , (normalize_fname here : Source_code_position.t)
      , { was_set_here = (was_set_here |> normalize_fname : Source_code_position.t) }]
;;

let arg here =
  if%map_open.Command
    Arg.flag
      [ "use-small-game-dimensions" ]
      ~doc:"Replace normal dimensions by smaller ones for quick tests."
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
