(*********************************************************************************)
(*  super-master-mind: A solver for the super master mind game                   *)
(*  SPDX-FileCopyrightText: 2021-2025 Mathieu Barbin <mathieu.barbin@gmail.com>  *)
(*  SPDX-License-Identifier: MIT                                                 *)
(*********************************************************************************)

let () =
  Cmdlang_cmdliner_err_runner.run
    Super_master_mind.main
    ~name:"super-master-mind"
    ~version:"%%VERSION%%"
;;
