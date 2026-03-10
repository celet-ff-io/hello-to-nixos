<!-- markdownlint-disable MD024 -->

# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added

- Add `programs.hyprland.plugins.hyprexpo.enable`
  to make Hyprexpo plugin could be disabled.
- Add `programs.hyprland.plugins.hyprexpo.enable`
  to make it could be not installed
  in case that Hyprexpo and Hyprland do not share the same version
  however building of Hyprexpo usually requires the same version of Hyprland.

### Changed

- Disable pkgs.qemu_full.cephSupport.

## 2.0.1 - 2026-03-09

- Fix bug in `./modules/common/optional/default.nix`.

## 2.0.0 - 2026-03-09

### Added

- Add `./modules/common/optional/default.nix`
to import all modules under `./modules/common/optional`.

### Changed

- **Usage of this OS configuration repository is changed**
to importing modules of this repository in user's own `/etc/nixos`,
wherever the repository is located,
instead of make the repository itself as `/etc/nixos`
and add custom user configuration in `/etc/nixos/userspec`.

- The working modules under repository root,
`./common` and `./devspec`, are moved to `./modules`.  
e.g. `./common/basic-software.nix` to `./modules/common/basic-software.nix`.

- Modify `README.md` for usage change.

### Removed

- Delete everything in `.gitignore`
because all its current content are no longer useful.

- Delete useless `./userspec`
since we do not need git ignoring for custom configuration anymore.

## 1.1.1 - 2026-03-09

### Fixed

- Perfect `README.md`.

## 1.1.0 - 2026-03-09

### Changed

- Move timezone setting from `./devspec/locale.nix` to `./common/basic-software.nix`
  to make it works in WSL.

## [1.0.2] - 2026-03-09

### Added

- Add `CHANGELOG.md`.

### Fixed

- Perfect `README.md`.

## [1.0.1] - 2026-03-09

### Fixed

- Fix bug in `template-configuration.nix`.

## [1.0.0] - 2026-03-09

### Added

- Everything of the first release of Hello-to-NixOS I.
