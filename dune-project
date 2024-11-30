(lang dune 3.17)

(name super-master-mind)

(generate_opam_files)

(license MIT)

(authors "Mathieu Barbin")

(maintainers "Mathieu Barbin <opensource@mbarbin.org>")

(source
 (github mbarbin/super-master-mind))

(documentation "https://mbarbin.github.io/super-master-mind/odoc/")

(package
 (name super-master-mind)
 (synopsis "A solver for the super master mind game")
 (depends
  (ocaml
   (>= 5.2))
  (base
   (and
    (>= v0.17)
    (< v0.18)))
  (cmdlang
   (>= 0.0.9))
  (cmdlang-cmdliner-runner
   (>= 0.0.8))
  (cmdliner
   (>= 1.3.0))
  (domainslib
   (>= 0.5))
  (nonempty-list
   (and
    (>= v0.17)
    (< v0.18)))
  (ocaml-embed-file
   (and
    (>= v0.17)
    (< v0.18)))
  (parsexp
   (and
    (>= v0.17)
    (< v0.18)))
  (patdiff
   (and
    (>= v0.17)
    (< v0.18)))
  (ppx_compare
   (and
    (>= v0.17)
    (< v0.18)))
  (ppx_enumerate
   (and
    (>= v0.17)
    (< v0.18)))
  (ppx_hash
   (and
    (>= v0.17)
    (< v0.18)))
  (ppx_here
   (and
    (>= v0.17)
    (< v0.18)))
  (ppx_let
   (and
    (>= v0.17)
    (< v0.18)))
  (ppx_sexp_conv
   (and
    (>= v0.17)
    (< v0.18)))
  (ppx_sexp_value
   (and
    (>= v0.17)
    (< v0.18)))
  (ppxlib
   (>= 0.33))
  (progress
   (>= 0.3.0))
  (stdio
   (and
    (>= v0.17)
    (< v0.18)))))

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
   (and
    (>= v0.17)
    (< v0.18)))
  (bisect_ppx
   (and
    :with-dev-setup
    (>= 2.8.3)))
  (cmdlang
   (>= 0.0.9))
  (cmdlang-cmdliner-runner
   (>= 0.0.8))
  (cmdlang-to-cmdliner
   (>= 0.0.9))
  (cmdliner
   (>= 1.3.0))
  (domainslib
   (>= 0.5))
  (expect_test_helpers_core
   (and
    (>= v0.17)
    (< v0.18)))
  (nonempty-list
   (and
    (>= v0.17)
    (< v0.18)))
  (ocaml-embed-file
   (and
    (>= v0.17)
    (< v0.18)))
  (parsexp
   (and
    (>= v0.17)
    (< v0.18)))
  (patdiff
   (and
    (>= v0.17)
    (< v0.18)))
  (ppx_compare
   (and
    (>= v0.17)
    (< v0.18)))
  (ppx_enumerate
   (and
    (>= v0.17)
    (< v0.18)))
  (ppx_expect
   (and
    (>= v0.17)
    (< v0.18)))
  (ppx_hash
   (and
    (>= v0.17)
    (< v0.18)))
  (ppx_here
   (and
    (>= v0.17)
    (< v0.18)))
  (ppx_js_style
   (and
    :with-dev-setup
    (>= v0.17)
    (< v0.18)))
  (ppx_let
   (and
    (>= v0.17)
    (< v0.18)))
  (ppx_sexp_conv
   (and
    (>= v0.17)
    (< v0.18)))
  (ppx_sexp_value
   (and
    (>= v0.17)
    (< v0.18)))
  (ppxlib
   (>= 0.33))
  (progress
   (>= 0.3.0))
  (stdio
   (and
    (>= v0.17)
    (< v0.18)))))
