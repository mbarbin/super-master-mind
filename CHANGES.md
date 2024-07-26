## 0.0.7 (2024-07-26)

### Added

- Added dependabot config for automatically upgrading action files.

### Changed

- Upgrade `ppxlib` to `0.33` - activate unused items warnings.
- Upgrade `ocaml` to `5.2`.
- Upgrade `dune` to `3.16`.
- Upgrade base & co to `0.17`.

## 0.0.6 (2024-03-13)

### Changed

- Uses `expect-test-helpers` (reduce core dependencies)
- Run `ppx_js_style` as a linter & make it a `dev` dependency.
- Upgrade GitHub workflows `actions/checkout` to v4.
- In CI, specify build target `@all`, and add `@lint`.
- List ppxs instead of `ppx_jane`.

## 0.0.5 (2024-02-14)

### Changed

- Upgrade dune to `3.14`.
- Build the doc with sherlodoc available to enable the doc search bar.

## 0.0.4 (2024-02-09)

### Changed

- Internal changes related to the release process.
- Upgrade dune and internal dependencies.
- Improve `bisect_ppx` setup for test coverage.

### Fixed

- Make positions more stable in expect tests.

## 0.0.3 (2024-01-18)

### Changed

- Internal changes related to build and release process.
- Generate opam file from `dune-project`.
- Change how progress is reported during the computation of the opening-book.
  Now displays [progress](https://github.com/craigfe/progress) bars.

### Removed

- Refactor to remove `Core_kernel` and `ANSITerminal` dependencies.

## 0.0.2 (2023-11-01)

### Changed

- Change changelog format to be closer to dune-release's.
- Now building distribution with `dune-release`.
- Internal refactoring related to -open via flags.

### Fixed

- Make `super-master-mind -version` output the package version.

## 0.0.1 (2023-10-30)

### Added

- Added changelog (#1)

### Changed

- Uses [Domainslib] to run computation in parallel. In particular this speeds-up
  the computation of the opening-book.
