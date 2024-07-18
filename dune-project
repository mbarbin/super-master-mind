(lang dune 3.16)

(name super-master-mind)

(generate_opam_files)

(license MIT)

(authors "Mathieu Barbin")

(maintainers "Mathieu Barbin")

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
  (bisect_ppx
   (and
    :dev
    (>= 2.8.3)))
  (command-unix-for-opam
   (>= 0.0.2))
  (core
   (and
    (>= v0.17)
    (< v0.18)))
  (domainslib
   (>= 0.5))
  (expect-test-helpers
   (and
    :with-test
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
    :with-test
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
    :dev
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
   (>= 0.32))
  (progress
   (>= 0.3.0))
  (stdio
   (and
    (>= v0.17)
    (< v0.18)))))
