# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html)

## 0.3.0 - 2021-08-23

### Added

- Added `caddy`. This is useful for testing the Spider project against regular back-ends for the reverse proxy side of things.
- Added `gmock`. Some CMake projects failed due to a hidden dependency on GMock when using GTest.

### Changed

- Updated base image to `archlinux:base-devel-20210815.0.31571`.
- Explicitly require bash for a script due to the use of `pushd`.
- Added `set -e` to scripts to properly report errors.

## 0.2.0 - 2021-03-09
### Added

- Add `gtest` and `cmake`. CMake was already implicitly installed via install criterion, it is now explicitly installed with the other packages.

### Removed

- Removed glibc patch that was used for fixing things

## 0.1.0 - 2021-02-28

Initial release
