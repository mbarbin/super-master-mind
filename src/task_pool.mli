(*_********************************************************************************)
(*_  super-master-mind: A solver for the super master mind game                   *)
(*_  SPDX-FileCopyrightText: 2021-2025 Mathieu Barbin <mathieu.barbin@gmail.com>  *)
(*_  SPDX-License-Identifier: MIT                                                 *)
(*_********************************************************************************)

(** To perform computation in parallel, we use [Domainslib]. This module is a
    thin wrapper on top of [Domainslib.Task], which allows to make it easier
    to use it correctly, and allows for changing parameters from the command
    line, via the [Config] module. *)

type t

module Config : sig
  (** Internally, [Config.t] holds the number of {e worker} domains to spawn,
      not including the main domain. Since the main domain also participates in
      the work when calling {!run}, the total parallelism is [num_workers + 1].

      There are two ways to obtain a [Config.t]:

      - {!default}: Returns a config with [Domain.recommended_domain_count () - 1]
        workers, resulting in total parallelism equal to the recommended count.

      - {!arg}: Users specify the {e total} number of cores they want to use
        (e.g., [--num-domains 8]), and the adjustment is applied internally. *)
  type t

  (** By default, use all available cores on the machine. The number of workers
      is [Domain.recommended_domain_count () - 1] because the main domain also
      participates in the work. See [Domain.recommended_domain_count] for more
      details. *)
  val default : unit -> t

  (** Commands that desire to expose task pool parameters to the user can use
      [arg]. Otherwise see [default].

      Note: The CLI flag [--num-domains] expects the {e total} number of cores
      to use, including the main domain. The adjustment of [-1] is applied
      internally. *)
  val arg : t Command.Arg.t
end

(** This wrapper takes care of setting up the task pool, and tearing it down
    when finished. It is meant to wrap the entire part of a command that will
    make use of the task pool. *)
val with_t : Config.t -> f:(task_pool:t -> 'a) -> 'a

(** To be called each time you want to make use of the task pool. This wraps [f]
    within a call to [Domainslib.Task.run]. *)
val run : t -> f:(pool:Domainslib.Task.pool -> 'a) -> 'a
