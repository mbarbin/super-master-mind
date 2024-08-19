let () =
  Cmdliner.Cmd.eval
    (Commandlang_to_cmdliner.Translate.command
       Super_master_mind.main
       ~name:"super-master-mind"
       ~version:"%%VERSION%%")
  |> Stdlib.exit
;;
