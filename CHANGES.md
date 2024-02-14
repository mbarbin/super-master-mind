## 0.0.5 (unreleased)

### Added

### Changed

- Upgrade dune to `3.14`.
- Build the doc with sherlodoc available to enable the doc search bar.

### Deprecated

### Fixed

### Removed

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
