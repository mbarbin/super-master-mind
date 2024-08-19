(** To perform computation in parallel, we use [Domainslib]. This module is a
    thin wrapper on top of [Domainslib.Task], which allows to make it easier
    to use it correctly, and allows for changing parameters from the command
    line, via the [Config] module. *)

type t

module Config : sig
  type t

  val default : t

  (** Commands that desire to expose task pool parameters to the user can use
      [arg]. Otherwise see [default]. *)
  val arg : t Command.Arg.t
end

(** This wrapper takes care of setting up the task pool, and tearing it down
    when finished. It is meant to wrap the entire part of a command that will
    make use of the task pool. *)
val with_t : Config.t -> f:(task_pool:t -> 'a) -> 'a

(** To be called each time you want to make use of the task pool. This wraps [f]
    within a call to [Domainslib.Task.run]. *)
val run : t -> f:(pool:Domainslib.Task.pool -> 'a) -> 'a
