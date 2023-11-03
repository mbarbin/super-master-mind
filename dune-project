(lang dune 3.11)

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
 (description "A solver for the super master mind game")
 (depends
  (ocaml
   (>= 5.1))
  (dune
   (>= 3.11))
  (ANSITerminal
   (>= 0.8.3))
  (base
   (and
    (>= v0.16)
    (< v0.17)))
  (bisect_ppx
   (and
    :dev
    (>= 2.8)))
  (core
   (and
    (>= v0.16)
    (< v0.17)))
  (core_kernel
   (and
    (>= v0.16)
    (< v0.17)))
  (core_unix
   (and
    (>= v0.16)
    (< v0.17)))
  (dmonainslib
   (>= 0.5))
  (expect_test_helpers_core
   (and
    :with-test
    (>= v0.16)
    (< v0.17)))
  ocaml-embed-file
  (parsexp
   (and
    (>= v0.16)
    (< v0.17)))
  (ppx_jane
   (and
    (>= v0.16)
    (< v0.17)))
  (ppx_js_style
   (and
    (>= v0.16)
    (< v0.17)))
  (sexp_diff
   (and
    (>= v0.16)
    (< v0.17)))
  (stdio
   (and
    (>= v0.16)
    (< v0.17)))))
