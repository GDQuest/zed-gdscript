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

Note that the installed program might be called `nc` or `ncat`, depending on your operating system and package manager (short for netcat). The extension will try to find either of them in your system PATH.

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

### Opening documentation in the Godot editor

You can configure Godot to open the relevant documentation page when running the `editor: go to declaration` command on a built-in piece of code.

First, in Godot, open the Editor Settings. Then, go to Network -> Language Server and turn on Show Native Symbols in Editor. This configures the language server to open documentation pages in the Godot editor on demand.

From there, in Zed, you can use the command `editor: go to declaration` to open the documentation in the editor. Note that it will **not** work with the `editor: go to definition` command (last tested in Godot 4.6.1).

## Formatting

Zed provides the ability to format files using an external formatter. There are a few options for GDScript formatting.

### With [GDScript formatter](https://github.com/GDQuest/GDScript-formatter)

[GDScript formatter](https://github.com/GDQuest/GDScript-formatter) is a fast code formatter and linter that is built with the same [tree-sitter-gdscript](https://github.com/PrestonKnopp/tree-sitter-gdscript) grammar that this extension uses.

Install it and make sure that `gdscript-formatter` is available in your system PATH.

Then, add the following configuration to your `settings.json` file:

```json
{
  "languages": {
    "GDScript": {
      "formatter": {
        "external": {
          "command": "gdscript-formatter",
          "arguments": []
        }
      }
    }
  }
}
```

### With [GDScript Toolkit](https://github.com/Scony/godot-gdscript-toolkit)

[GDScript Toolkit](https://github.com/Scony/godot-gdscript-toolkit) is a Python-based formatter and linter for GDScript.

Install it and make sure that `gdformat` is available in your system PATH.

Then, add the following configuration to your `settings.json` file:

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

## Debugging

> [!NOTE]
> At the time of writing this, debugging will not work when using Godot 4.4. It's confirmed to work in Godot 4.3 and 4.5, however.

The extension provides a debug adapter that allows debugging GDScript code. To be able to do this, create `.zed/debug.json` file in the root of your workspace with the following content:

```json
[
  {
    "adapter": "godot",
    "label": "Godot (Launch)",
    "request": "launch"
  },
  {
    "adapter": "godot",
    "label": "Godot (Attach)",
    "request": "attach"
  }
]
```

This will add 2 debug tasks: `Godot (Launch)` will launch a new debugging session, while `Godot (Attach)` will try to attach to an existing one. To run these tasks, press `F4`, then select the desired task from the menu.

Complete list of options can be found in [`debug_adapter_schemas/godot.json`](debug_adapter_schemas/godot.json). Zed will also suggest possible options through autocompletion when editing the `debug.json` file.

## Contributing

- [Contributing to Scheme files](docs/contributing_scheme_files.md)
