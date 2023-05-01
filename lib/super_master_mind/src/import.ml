open! Core

module Float = struct
  include Float

  let log2 = Caml.Float.log2
end
