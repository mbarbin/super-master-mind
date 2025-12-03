module Sites : sig
  (** The opening_book site contains a file that is computed during development,
      and installed with the package, to be loaded at runtime. The exact name of
      the expected file is configured in [%{PROJECT_ROOT}/opening-book/dune]. *)
  val opening_book : string list
end
