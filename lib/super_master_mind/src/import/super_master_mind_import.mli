module Float : sig
  include module type of struct
    include Float
  end

  (** This function is available as [Stdlib.Float.log2] from OCaml 4.13 but
      hasn't made it to [Core.Float] yet. To be simplified when it does. *)
  val log2 : t -> t
end
