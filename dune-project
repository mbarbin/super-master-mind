(lang dune 3.20)

(name super-master-mind)

(generate_opam_files)

(license MIT)

(authors "Mathieu Barbin")

(maintainers "Mathieu Barbin <opensource@mbarbin.org>")

(source
 (github mbarbin/super-master-mind))

(documentation "https://mbarbin.github.io/super-master-mind/odoc/")

(implicit_transitive_deps false)

(package
 (name super-master-mind)
 (synopsis "A solver for the super master mind game")
 (depends
  (ocaml
   (>= 5.2))
  (base
   (>= v0.17))
  (cmdlang
   (>= 0.0.10))
  (domainslib
   (>= 0.5))
  (nonempty-list
   (>= v0.17))
  (ocaml-embed-file
   (>= v0.17))
  (parsexp
   (>= v0.17))
  (patdiff
   (>= v0.17))
  (pplumbing
   (>= 0.0.14))
  (ppx_compare
   (>= v0.17))
  (ppx_enumerate
   (>= v0.17))
  (ppx_hash
   (>= v0.17))
  (ppx_here
   (>= v0.17))
  (ppx_let
   (>= v0.17))
  (ppx_sexp_conv
   (>= v0.17))
  (ppx_sexp_value
   (>= v0.17))
  (ppxlib
   (>= 0.33))
  (progress
   (>= 0.3.0))
  (stdio
   (>= v0.17))))

(package
 (name super-master-mind-tests)
 (synopsis "Tests for super-master-mind")
 (depends
  (ocaml
   (>= 5.2))
  (ocamlformat
   (and
    :with-dev-setup
    (= 0.27.0)))
  (base
   (>= v0.17))
  (bisect_ppx
   (and
    :with-dev-setup
    (>= 2.8.3)))
  (cmdlang
   (>= 0.0.10))
  (domainslib
   (>= 0.5))
  (expect_test_helpers_core
   (>= v0.17))
  (nonempty-list
   (>= v0.17))
  (ocaml-embed-file
   (>= v0.17))
  (parsexp
   (>= v0.17))
  (patdiff
   (>= v0.17))
  (pplumbing
   (>= 0.0.14))
  (ppx_compare
   (>= v0.17))
  (ppx_enumerate
   (>= v0.17))
  (ppx_expect
   (>= v0.17))
  (ppx_hash
   (>= v0.17))
  (ppx_here
   (>= v0.17))
  (ppx_js_style
   (and
    :with-dev-setup
    (>= v0.17)))
  (ppx_let
   (>= v0.17))
  (ppx_sexp_conv
   (>= v0.17))
  (ppx_sexp_value
   (>= v0.17))
  (ppxlib
   (>= 0.33))
  (progress
   (>= 0.3.0))
  (stdio
   (>= v0.17))
  (sherlodoc
   (and
    :with-doc
    (>= 0.2)))))
