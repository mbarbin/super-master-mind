## 0.0.3-preview.1

This is a preview release used for testing.

### Changed

- Change how progress is reported during the computation of the opening-book.
  Now displays [progress](https://github.com/craigfe/progress) bars.

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
