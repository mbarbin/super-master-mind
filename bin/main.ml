let () =
  Cmdlang_cmdliner_runner.run
    Super_master_mind.main
    ~name:"super-master-mind"
    ~version:"%%VERSION%%"
;;
