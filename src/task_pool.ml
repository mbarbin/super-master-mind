(*********************************************************************************)
(*  super-master-mind: A solver for the super master mind game                   *)
(*  SPDX-FileCopyrightText: 2021-2025 Mathieu Barbin <mathieu.barbin@gmail.com>  *)
(*  SPDX-License-Identifier: MIT                                                 *)
(*********************************************************************************)

module Config = struct
  type t = { num_workers : int }

  let default () = { num_workers = Domain.recommended_domain_count () - 1 }

  let arg =
    let open Command.Std in
    let+ num_domains =
      Arg.named_opt
        [ "num-domains" ]
        Param.int
        ~doc:
          "Total number of cores to use for parallel computing, including the main \
           domain. By default, use all available cores."
    in
    let default = lazy (default ()) in
    let num_workers =
      match num_domains with
      | Some n -> n - 1
      | None -> (Lazy.force default).num_workers
    in
    { num_workers }
  ;;
end

type t = { pool : Domainslib.Task.pool }

let with_t { Config.num_workers } ~f =
  let pool = Domainslib.Task.setup_pool ~num_domains:num_workers () in
  let (t : t) = { pool } in
  Fun.protect
    ~f:(fun () -> f ~task_pool:t)
    ~finally:(fun () -> Domainslib.Task.teardown_pool pool)
;;

let run t ~f = Domainslib.Task.run t.pool (fun () -> f ~pool:t.pool)
