# Licence

super-master-mind is released under the terms of the `MIT` license.

This notice file contains more details, as well as document the organization of files and headers that relate to licenses.

## License, copyright & notices

- **COPYING.HEADER** contains the copyright and license notices. It is added as a header to every file in the project.

- **LICENSE** contains the MIT license for the project.

- **NOTICE.md** (this file) documents the project licensing.

## Third party licenses

Under `third-party-license/` we include license of software used as vendored code.

### A note about Dyn

We vendor the module `Dyn` from the [dune](https://github.com/ocaml/dune) project. Dune is released under `MIT`. From time to time we may carry some minor changes.

The files we imported are in `src/stdlib/dyn0.ml{,i}`. We've added a notice in the files and a comment next to the code that was copied and modified. We've included `Dune`'s original LICENSE, and also included it in this repo at ``third-party-license/ocaml/dune/LICENSE.md`.

### A note about Nonempty_list

`Nonempty_list0` is a reimplementation inspired by Jane Street's [nonempty-list](https://github.com/janestreet/nonempty_list) (released under `MIT`). Some definitions such as `Summable` and `Or_unequal_lengths` are verbatim from [Base](https://github.com/janestreet/base).

### A note about ocaml-merge3 (Myers diff)

The Myers shortest-edit-script computation in `src/myers/merge3.ml` is vendored from [ocaml-merge3](https://tangled.org/gazagnaire.org/ocaml-merge3) by Thomas Gazagnaire (released under `ISC`). Only the pure diff computation is vendored; the parts unused by this project are not included. The exact provenance and list of changes are documented at the top of `src/myers/merge3.ml` and in `src/myers/vendor.json`. A copy of the license file is included in this repo at `third-party-license/gazagnaire/ocaml-merge3/LICENSE`.

### A note about Windtrap (unified-diff renderer)

The unified-diff renderer in `src/myers/myers.ml` is vendored from [windtrap](https://github.com/invariant-hq/windtrap) by Invariant Systems (released under `ISC`), with minor modifications to the rendering of diffs. The exact provenance and list of changes are documented at the top of `src/myers/myers.ml` and in `src/myers/vendor.json`. A copy of the license file is included in this repo at `third-party-license/invariant-hq/windtrap/LICENSE`.
