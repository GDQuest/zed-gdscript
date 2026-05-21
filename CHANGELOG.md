# Changelog

This file documents the changes made to the formatter with each release. This project uses [semantic versioning](https://semver.org/spec/v2.0.0.html).

## Release 0.9.0 (2026-05-21)

This release improves syntax highlighting in both GDScript and Godot shaders. Thanks to @YuriSizov for all the contributions!

### Added

- Highlight setget methods and punctuation in GDScript
- Improve highlighting for Godot shaders

### Changed

- Rewrite and expand contributing docs for Scheme files 

### Fixed

- Fix highlighting for GDScript constructors 

## Release 0.8.0 (2026-04-11)

This release improves GDScript syntax highlighting and adds many options for customizing the highlighting. Thanks much to @Fuzzycc for the help.

### Added

- Add `.gdshaderinc` file extension support to the GDShader grammar
- Add `playArgs` and `scene` properties to the DAP schema
- Improve GDScript syntax highlighting, add customization options and support for more detailed community themes

### Changed

- README:
  - Add a section about opening documentation in the editor
  - Add a note to the about using gdscript-formatter
  - Clarify that netcat may be installed as `nc` or `ncat`

## Release 0.7.0 (2025-10-23)

### Added

- Change the highlighting of docstring comments to stand out from regular comments
- Highlight property access like in Rust, javascript, and other languages
- Highlight breakpoints
- Allow overriding LSP binary path and environment variables in settings

### Changed

- Make a new release script (to make it easier and faster to create releases)

## Release 0.6.0 (2025-10-10)

### Added

- Debugging support
- Auto-closing of quotes and support for auto-closing in brackets
- Syntax highlighting for regions
- Support for GDShader
- Outline view: `_init()` constructor method is now listed

### Changed

- Updated `tree-sitter-gdscript`
- Added highlighting for missing GDScript operators
- Capitalized identifiers are now marked as types
- Strip debug symbols on release builds to reduce download sizes

### Fixed

- Highlight: identifiers in `binary_operator` being incorrectly marked as types
- Highlight: some built-in types not being marked as types
- Capitalized identifiers not being marked as constants
