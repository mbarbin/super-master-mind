(** Print and return the steps that lead to finding the solution given as
    parameter. *)
val solve
  :  task_pool:Task_pool.t
  -> color_permutation:Color_permutation.t Lazy.t
  -> solution:Code.t
  -> Guess.t list

(** A command that runs [solve]. *)
val cmd : Command.t
