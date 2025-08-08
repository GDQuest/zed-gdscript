# Zed GDScript Extension

This extension adds support for [GDScript](https://docs.godotengine.org/en/stable/classes/index.html), the scripting language used in the Godot game engine, to the Zed editor.

## Requirements

- Zed Editor.
- Godot Engine (version 3.x or 4.x).
- The program `nc` or `ncat` is available in your system PATH.

## How to install

To get language server support in Godot, you will first need to install the Netcat program. Netcat is a small program that allows Zed and Godot to communicate with each other.

### Installing Netcat

You can install Netcat from your package manager:

- On Ubuntu/Debian Linux: `sudo apt install netcat`.
- On Fedora Linux: `sudo dnf install nmap-ncat`.
- On macOS: `brew install netcat`.

### Installing the Zed GDScript Extension

1. Open Zed.
2. Go to Extensions.
3. Search for *GDScript*.
4. Click Install.

### Starting the Godot Language Server

Unlike other programming languages, Godot's language server is part of the Godot editor. Godot uses the context of your project and scene files to provide auto-completion and project-specific error checks. So, to get the full experience of the Godot language server, you need to open your project in Godot.

After opening Godot, in Zed, you can use the command *editor: restart language server* to connect to Godot's language server.

### Opening GDScript files in Zed instead of Godot

If you want to open GDScript files in Zed instead of Godot, you need to change Godot editor settings. In the Godot editor, go to *Editor > Editor Settings > Text Editor > External* and enable *Use External Editor*. Set the *Exec Path* to the path of your Zed executable and the *Exec Flags* to `{project} {file}:{line}:{col}`. This will open files and jump to the correct line in Zed when you click on an error or warning in Godot.

If you have installed Godot and Zed via Flatpak on Linux, use the following parameters:

1. Set "Exec Path" to `flatpak-spawn`.
2. Set "Exec Flags" to `--host flatpak run dev.zed.Zed {project} {file}:{line}:{col}`.

## Configuration

Godot's language server is part of the Godot editor, and you need to open your project in Godot to use it.

By default, the extension matches the default settings of the Godot editor to connect to its language server:

- Remote Host: 127.0.0.1
- Remote Port: 6005

You can change these settings in Godot by going to *Editor > Editor Settings > Network > Language Server*. If you do that, you'll need to change the settings in Zed to match. You can change these settings by adding the following JSON configuration to your `settings.json` file:

```json
{
  "lsp": {
    "gdscript": {
      "binary": {
        "arguments": ["127.0.0.1", "6005"]
      }
    }
  }
}
```

Optionally, if you have [`godot-gdscript-toolkit`](https://github.com/Scony/godot-gdscript-toolkit) installed, you can use `gdformat` to format GDScript files:

```json
{
  "languages": {
    "GDScript": {
      "formatter": {
        "external": {
          "command": "gdformat",
          "arguments": ["-"]
        }
      }
    }
  }
}
```

## Contributing

## Editing .scm files

The `.scm` files in this repository are configuration files that capture the syntax and structure of GDScript code. They are used by the Zed editor to provide features like syntax highlighting, code folding, and symbol outlines.

They're written in the Scheme language and use Tree-Sitter to capture different bits.

The names and elements used in those files are, in large part, specific to the language you are working on. To edit them, you need to parse a source code file using the Tree-Sitter parser for that language.

### Parsing GDScript with Tree-Sitter

The Zed editor uses a technology called Tree-Sitter to parse languages and create the outlines and syntax highlighting you see when using the extension. This technology allows people in the community to define a grammar for parsing a language, and Tree-Sitter will generate a parser for that language optimized for code editors.

The parser configuration for GDScript is maintained by PrestonKnopp: [tree-sitter-gdscript](https://github.com/PrestonKnopp/tree-sitter-gdscript).

In the `languages/gdscript` folder, you will find a series of `.scm` files that use syntax parsed by Tree-Sitter to capture symbols or specific portions of the code and add the features you see in Zed. To understand how these files work, you need to parse a GDScript file with PrestonKnopp's Tree-Sitter grammar. To do that, you need to:

1. Install Tree-Sitter on your system. You can find the installation instructions in the [Tree-Sitter CLI README](https://github.com/tree-sitter/tree-sitter/blob/master/crates/cli/README.md).
2. Clone the [tree-sitter-gdscript](https://github.com/PrestonKnopp/tree-sitter-gdscript) repository.
3. Build the parser by running `tree-sitter generate` in the cloned repository.
4. Register the parser in your Tree-Sitter configuration. In a file named `config.json` in `~/.config/tree-sitter`, add the following:
  ```json
  {
    "parser-directories": ["/path/to/your/tree-sitter-repositories"]
  }
  ```
5. Use the generated parser to parse a GDScript file, for example:
  ```bash
  tree-sitter parse --scope source.gdscript data/parsing_test.gd
  ```

The `--scope` option is used to tell Tree-Sitter what language to use for parsing. In this case, `source.gdscript` is the name used to identify GDScript in the Tree-Sitter grammar. The `data/parsing_test.gd` file is a sample GDScript file that you can use to test the parser.

It should give you an output that looks like this and shows the structure of the GDScript file:

```scm
(source [0, 0] - [11, 0]
  (comment [0, 0] - [0, 80])
  (class_name_statement [1, 0] - [1, 18]
    (name [1, 11] - [1, 18]))
  (extends_statement [1, 19] - [1, 35]
    (type [1, 27] - [1, 35]
      (identifier [1, 27] - [1, 35])))
  (variable_statement [3, 0] - [3, 34]
    name: (name [3, 4] - [3, 12])
    type: (inferred_type [3, 13] - [3, 15])
    value: (call [3, 16] - [3, 34]
      (identifier [3, 16] - [3, 23])
      (arguments [3, 23] - [3, 34]
        (integer [3, 24] - [3, 27])
        (unary_operator [3, 29] - [3, 33]
          (integer [3, 30] - [3, 33])))))
; ...
```

### Understanding queries in the `.scm` files

The `.scm` files in the `languages/gdscript` folder use queries to match specific parts of the GDScript code. These queries are written in a syntax that is specific to Tree-Sitter and allow you to define patterns to match against the parsed structure of the code.

For example, a query might look like this:

```scm
(source
    (variable_statement .
        "var" @context
        name: (_) @name
    ) @item)
```

This means: Capture/find a variable definition that is a direct child of the source node. The `@context`, `@name`, and `@item` are types of directives that Zed uses to know what to do with the matched nodes:

- `@context` is used to indicate what this is (in this case, a "var")
- `@name` captures the name of the symbol (in this case, the variable's name in the source code)
- `@item` captures the entire variable statement with its name and context so that when you click on it in Zed, it can take you to the right place in the code
