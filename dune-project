(lang dune 3.20)

(name super-master-mind)

(generate_opam_files)

(license MIT)

(authors "Mathieu Barbin")

(maintainers "Mathieu Barbin <opensource@mbarbin.org>")

(source
 (github mbarbin/super-master-mind))

(documentation "https://mbarbin.github.io/super-master-mind/odoc/")

(using dune_site 0.1)

(implicit_transitive_deps false)

(package
 (name super-master-mind)
 (synopsis "A solver for the super master mind game")
 (sites
  (share opening_book))
 (depends
  (ocaml
   (>= 5.2))
  (cmdlang
   (>= 0.0.10))
  (cmdlang-cmdliner-err-runner
   (>= 0.0.16))
  (domainslib
   (>= 0.5))
  (dune-site
   (>= 3.20))
  (dyn
   (>= 3.20))
  (nonempty-list
   (>= v0.17))
  (ordering
   (>= 3.20))
  (patdiff
   (>= v0.17))
  (pp
   (>= 2.0.0))
  (ppxlib
   (>= 0.33))
  (progress
   (>= 0.3.0))
  (yojson
   (>= 2.2))))

(package
 (name super-master-mind-tests)
 (synopsis "Tests for super-master-mind")
 (depends
  (ocaml
   (>= 5.2))
  (cmdlang
   (>= 0.0.10))
  (cmdlang-cmdliner-err-runner
   (>= 0.0.16))
  (domainslib
   (>= 0.5))
  (nonempty-list
   (>= v0.17))
  (patdiff
   (>= v0.17))
  (ppx_expect
   (>= v0.17))
  (ppxlib
   (>= 0.33))
  (progress
   (>= 0.3.0))
  (super-master-mind
   (= :version))))

(package
 (name super-master-mind-dev)
 (synopsis "Package to regroup dev targets, documentation, and more")
 (allow_empty)
 (depends
  (ocaml
   (>= 5.2))
  (ocamlformat
   (= 0.28.1))
  (bisect_ppx
   (>= 2.8.3))
  (cmdlang
   (>= 0.0.10))
  (cmdlang-cmdliner-err-runner
   (>= 0.0.16))
  (domainslib
   (>= 0.5))
  (nonempty-list
   (>= v0.17))
  (ppx_expect
   (>= v0.17))
  (ppx_js_style
   (>= v0.17))
  (ppxlib
   (>= 0.33))
  (progress
   (>= 0.3.0))
  (super-master-mind
   (= :version))
  (super-master-mind-tests
   (= :version))
  (sherlodoc
   (>= 0.2))))
