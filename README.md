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
