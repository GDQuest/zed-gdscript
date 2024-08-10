# Zed GDScript Extension

This extension adds support for [GDScript](https://docs.godotengine.org/en/stable/classes/index.html), the scripting language used in the Godot game engine, to the Zed editor.

## Requirements

- Zed Editor
- Godot Engine (version 3.x or 4.x)
- `nc` (netcat) or `ncat` available in your system PATH

## Installation

1. Install this extension in Zed (instructions specific to Zed's extension installation process)
2. Ensure Godot is installed on your system
3. Set up the Godot language server (see below)

## Setting Up the Godot Language Server

The Godot Language Server should be running separately. Here are the steps to set it up:

1. Open your Godot project
2. Go to Editor > Editor Settings > Text Editor > External
3. Enable "Use External Editor"
4. Set "Exec Path" to the path of your Zed executable
5. Set "Exec Flags" to `{project} {file}:{line}:{col}`

Then, to start the language server:

1. Go to Editor > Editor Settings > Network > Language Server
2. Set "Remote Host" to `127.0.0.1`
3. Set "Remote Port" to `6005`
4. Restart Godot

## Configuration

Godot's language server is part of the Godot editor, and you need to open your project in Godot to use it.

By default, the extension matches the default settings of the Godot editor to connect to its language server:

- Remote Host: 127.0.0.1
- Remote Port: 6005

You can change these settings by adding the following JSON configuration to your `settings.json` file:

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
