open! Core

module Float = struct
  include Float

  let log2 =
    (* This function is available as [Float.log2] from OCaml 4.13. To be
     simplified upon upgrading to a more recent compiler. *)
    let log2 = lazy (Caml.Float.log 2.) in
    fun x -> Caml.Float.log x /. Lazy.force log2
  ;;
end
