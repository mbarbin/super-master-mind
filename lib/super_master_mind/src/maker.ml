let input_line () = In_channel.(input_line_exn stdin)

let rec input_code () =
  let prompt = "Please enter your guess: " in
  print_string prompt;
  Out_channel.(flush stdout);
  let line = input_line () in
  match
    line |> Parsexp.Single.parse_string_exn |> [%of_sexp: Code.Hum.t] |> Code.create_exn
  with
  | exception e ->
    print_s [%sexp (e : Exn.t)];
    input_code ()
  | code -> code
;;

let run ~solution =
  let code_size = force Cue.code_size in
  let rec aux i =
    let candidate = input_code () in
    let cue = Code.analyze ~solution ~candidate in
    let { Cue.Hum.white; black } = Cue.to_hum cue in
    print_s [%sexp (i : int), (candidate : Code.t)];
    print_endline (Printf.sprintf "#black (correctly placed)  : %d" black);
    print_endline (Printf.sprintf "#white (incorrectly placed): %d" white);
    Out_channel.(flush stdout);
    if black < code_size then aux (Int.succ i)
  in
  aux 1
;;

let cmd =
  Command.make
    ~summary:"run interactively"
    (let%map_open.Command solution =
       Arg.named_opt
         [ "solution" ]
         Code.param
         ~doc:"CODE chosen solution (default is random)"
     in
     let solution =
       match solution with
       | Some solution -> solution
       | None -> Code.of_index_exn (Random.int (force Code.cardinality)) [@coverage off]
     in
     run ~solution)
;;
