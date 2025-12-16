(*********************************************************************************)
(*  super-master-mind: A solver for the super master mind game                   *)
(*  SPDX-FileCopyrightText: 2021-2025 Mathieu Barbin <mathieu.barbin@gmail.com>  *)
(*  SPDX-License-Identifier: MIT                                                 *)
(*********************************************************************************)

let input_line () =
  match Stdlib.In_channel.input_line In_channel.stdin with
  | Some line -> line
  | None -> raise End_of_file
;;

let rec input_code () =
  let prompt = "Please enter your guess: " in
  Stdlib.print_string prompt;
  Out_channel.(flush stdout);
  let line = input_line () in
  match line |> Json.of_string |> Code.Hum.of_json |> Code.create_exn with
  | exception e ->
    Stdlib.print_endline (Stdlib.Printexc.to_string e);
    input_code ()
  | code -> code
;;

let run ~solution =
  let code_size = force Cue.code_size in
  let rec aux i =
    let candidate = input_code () in
    let cue = Code.analyze ~solution ~candidate in
    let { Cue.Hum.white; black } = Cue.to_hum cue in
    print_dyn (Dyn.Tuple [ i |> Dyn.int; candidate |> Code.to_dyn ]);
    Stdlib.print_endline (Printf.sprintf "#black (correctly placed)  : %d" black);
    Stdlib.print_endline (Printf.sprintf "#white (incorrectly placed): %d" white);
    Out_channel.(flush stdout);
    if black < code_size then aux (Int.succ i)
  in
  aux 1
;;

let cmd =
  Command.make
    ~summary:"Run interactively."
    (let open Command.Std in
     let+ solution =
       Arg.named_opt
         [ "solution" ]
         Code.param
         ~docv:"CODE"
         ~doc:"Specify a chosen solution (default is random)."
     in
     let solution =
       match solution with
       | Some solution -> solution
       | None -> Code.of_index_exn (Random.int (force Code.cardinality)) [@coverage off]
     in
     run ~solution)
;;
