(lang dune 3.13)

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
   (>= 5.1))
  (base
   (and
    (>= v0.16)
    (< v0.17)))
  (bisect_ppx
   (and
    :dev
    (>= 2.8)))
  (command-unix-for-opam
   (>= 0.0.2))
  (core
   (and
    (>= v0.16)
    (< v0.17)))
  (domainslib
   (>= 0.5))
  (expect_test_helpers_core
   (and
    :with-test
    (>= v0.16)
    (< v0.17)))
  (nonempty-list
   (and
    (>= v0.16)
    (< v0.17)))
  (ocaml-embed-file
   (and
    (>= v0.16)
    (< v0.17)))
  (parsexp
   (and
    (>= v0.16)
    (< v0.17)))
  (patdiff
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
  (progress
   (>= 0.2.3-preview))
  (stdio
   (and
    (>= v0.16)
    (< v0.17)))))
