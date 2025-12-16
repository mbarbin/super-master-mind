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
