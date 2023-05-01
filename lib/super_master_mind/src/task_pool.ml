open! Core

module Config = struct
  type t = { num_domains : int }

  let default = { num_domains = 4 }

  let param =
    let open Command.Let_syntax in
    let%map_open num_domains =
      flag
        "num-domains"
        (optional_with_default default.num_domains int)
        ~doc:"N num of domains for parallel computing"
    in
    { num_domains }
  ;;
end

type t = { pool : Domainslib.Task.pool }

let with_t { Config.num_domains } ~f =
  let pool = Domainslib.Task.setup_pool ~num_domains () in
  let (t : t) = { pool } in
  Exn.protect
    ~f:(fun () -> f ~task_pool:t)
    ~finally:(fun () -> Domainslib.Task.teardown_pool pool)
;;

let run t ~f = Domainslib.Task.run t.pool (fun () -> f ~pool:t.pool)
