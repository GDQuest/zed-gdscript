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

This extension assumes the Godot Language Server is running on the default IP `127.0.0.1` and port `6005`. If you need to change these settings, put the following in your `settings.json`:

```
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
