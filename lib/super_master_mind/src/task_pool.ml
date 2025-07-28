module Config = struct
  type t = { num_domains : int }

  let default = { num_domains = 4 }

  let arg =
    let%map_open.Command num_domains =
      Arg.named_with_default
        [ "num-domains" ]
        Param.int
        ~default:default.num_domains
        ~doc:"Num of domains for parallel computing."
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
