let () =
  Cmdlang_to_cmdliner.run
    Super_master_mind.main
    ~name:"super-master-mind"
    ~version:"%%VERSION%%"
;;
