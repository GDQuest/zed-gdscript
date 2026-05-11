# Contributing to Scheme (`.scm`) files

The `.scm` files are used by the Zed editor to provide features like syntax highlighting, code folding, and symbol outlines for supported languages. You can find the files used by this extension in the `languages/` folder, split into subfolders for GDScript, Godot shaders, and Godot resources.

These `.scm` files are written in the Scheme language, using the query syntax from the [Tree-sitter tool](https://tree-sitter.github.io/tree-sitter/). The *Tree-sitter* works behind the scenes in Zed to process open files and understand their syntax, and it can also be used directly — which will come in handy momentarily, when we discuss debugging.

As the name suggests, the query syntax allows Zed to look up elements in the parsed document using their attributes and characteristics, such as name, hierarchy, and relationships. Here's an example of a query written in Scheme:

```scm
(variable_statement
  name: (name) @variable)
```

We will get back to it soon.


## Setting up Tree-sitter

The *Tree-sitter* tool is a framework for creating grammar-based parsers for programming and markup languages. It's a standalone tool, and the Zed editor is but one of its users. Various other code editors also support the Tree-sitter.

Several parsers are available as a part of the Tree-sitter project. However, file formats developed for Godot require custom parsers. They are developed and maintained by the community, and we will use them to debug our Scheme queries.

To start off,

1. Install *Rust programming language* for your system using [rustup](https://rust-lang.org/tools/install/).
2. Install *Tree-sitter* with Rust's `cargo` package manager, following instructions in the [Tree-sitter CLI README](https://github.com/tree-sitter/tree-sitter/blob/master/crates/cli/README.md).
3. Create a folder anywhere in your system where you are going to put custom parsers.
4. Navigate to the `config.json` file for Tree-sitter. You can find it in `~/.config/tree-sitter` (on Linux) or `%APPDATA%/tree-sitter` (on Windows). If file doesn't exist, create it.
5. Add or edit the `parser-directories` property, and add the path to the folder you have created above:

```json
{
  "parser-directories": ["/path/to/your/tree-sitter-repositories"]
}
```

You can now start adding custom parsers. Clone the following repositories to their own subfolder inside the folder you have created above:

- [GDScript parser](https://github.com/PrestonKnopp/tree-sitter-gdscript).
- [Godot Shader parser](https://github.com/GodOfAvacyn/tree-sitter-gdshader)
- [Godot Resource parser](https://github.com/PrestonKnopp/tree-sitter-godot-resource)

To finish off, build each parser by running `tree-sitter generate` in their respective directories. You can then test that these parsers are now recognized by Tree-sitter using this command: `tree-sitter dump-languages`.

Once that is done, you can finally try it out. From the project's root, runn the following command:

```bash
tree-sitter parse --scope source.gdscript data/parsing_test.gd
```

After a few moments you should see the output.


## Using Tree-sitter for debugging

There are three particularly useful commands that you can use with `tree-sitter` to help you debug Scheme queries.

- `parse`
- `query`
- `playground`

### `parse` command

This commands runs a parser against the specified file and prints out a text representation of the abstract syntax tree (AST). To run the command, you need to specify the file that you want to process. If Tree-sitter doesn't recognize the file automatically, you can nudge it in the correct direction by using either `scope` or `grammar-path` flags:

```bash
tree-sitter parse --scope source.gdscript /path/to/file
tree-sitter parse --grammar-path /path/to/grammar/folder /path/to/file
```

The output may look something like this:

```scm
(source [0, 0] - [16, 0]
  (comment [0, 0] - [0, 81])
  (class_name_statement [1, 0] - [1, 35]
    name: (name [1, 11] - [1, 18])
    extends: (extends_statement [1, 19] - [1, 35]
      (type [1, 27] - [1, 35]
        (identifier [1, 27] - [1, 35]))))
  (variable_statement [3, 0] - [3, 34]
    name: (name [3, 4] - [3, 12])
    type: (inferred_type [3, 13] - [3, 15])
    value: (call [3, 16] - [3, 34]
      (identifier [3, 16] - [3, 23])
      arguments: (arguments [3, 23] - [3, 34]
        (integer [3, 24] - [3, 27])
        (unary_operator [3, 29] - [3, 33]
          (integer [3, 30] - [3, 33])))))
; ...
```

This is a nested, hierarchical representation of a GDScript document, or rather a part of it. Each block of text surrounded by parentheses represents a syntax element in the document, starting with the source document itself, called here `source`. In Tree-sitter terms it is also called a *node*.

Numbers in square brackets next to it describe the range, in pairs of line and character numbers, for which the node spans in the document. The example above tells us that the source document starts at line 0, character 0, and ends at line 16, character 0.

Each node may contain other nodes, and some of these nodes may be assigned to a named field of the parent node. For example, the `class_name_statement` node is contained on the line 1. It is the second child node of `source`, and in turn it contains named fields `name` and `extends`, each pointing to a new node inside. Nesting continues, as `extends` contains an `extends_statement` node, which contains a `type` node, which contains an `identifier` node.

These are not in any way unique names for the nodes in the document. You can spot in the example above that nodes `name`, `identifier`, and `integer` are used several times in different contexts. These nodes are called *named nodes*, and act like qualified types, for all intents and purposes.

Unless there are errors with the document or the parser, everything in the document gets turned into nodes. However, not everything is turned into named nodes. In the example above the `class_name_statement` node is notably missing a node for the `class_name` keyword itself. This is because the `class_name` keyword is turned into an anonymous node.

The limitation of the `parse` command is that it cannot display anonymous nodes. If it could, the node for the `class_name` keyword would look like this:

```scm
("class_name" [1, 0] - [1, 10])
```

Crucially, anonymous nodes are still a part of the formal grammar and are defined in the parser implementation. This means that despite a different form, they are every bit as strict as named nodes when it comes to queries. Anonymous nodes should not be confused with strings or fallback nodes when parser fails.

Actually, when parser fails it returns an `ERROR` node wherever it failed to recognize the syntax. Additionally, if it recognized the syntax but ran into an unknown, but recoverable situation, it can also return a `MISSING` node. These are not normally used in queries, but may indicate problems with the parser that need to be reported.

### `query` command

This commands executes all queries listed in the specified Scheme file against the specified target file, and returns a list of matches as they appear in the document.

For example, this will execute all GDScript highlight queries from this extension against the test file.

```bash
tree-sitter query --scope source.gdscript languages/gdscript/highlights.scm data/parsing_test.gd

```

The `grammar-path` options is also supported. The output may look something like this:

```
  pattern: 11
    capture: 8 - comment, start: (0, 0), end: (0, 81), text: `## Test script to parse using tree-sitter and see the abstract syntax tree (AST)`
  pattern: 12
    capture: 9 - comment.doc, start: (0, 0), end: (0, 81), text: `## Test script to parse using tree-sitter and see the abstract syntax tree (AST)`
  pattern: 42
    capture: 32 - keyword, start: (1, 0), end: (1, 10), text: `class_name`
  pattern: 1
    capture: 1 - type, start: (1, 11), end: (1, 18), text: `MyClass`
  pattern: 42
    capture: 32 - keyword, start: (1, 19), end: (1, 26), text: `extends`
  pattern: 18
    capture: 1 - type, start: (1, 27), end: (1, 35), text: `Sprite2D`
  pattern: 0
    capture: 0 - variable, start: (1, 27), end: (1, 35), text: `Sprite2D`
```

Each section starts with the index of the query that got a hit (`pattern`). It then lists the index and the name of the capture that was extracted from the match, matched range and the text value from the source document.

We will talk about captures below when we explainq queries, but in short, this is not dissimilar to named capture groups in regular expressions.

Indices used here are in order of the declaration in the used Scheme file. Capture indices would not necessarily align with query indices because multiple captures can be present in one query, and captures often get used multiple times across different queries.

### `playground` command

This command creates a local web server with an interactive playground for the specified parser and opens it in the browser. Only the `grammar-path` argument is accepted.

```bash
tree-sitter playground --grammar-path /path/to/grammar/folder
```

Before you can run it, the specified parser must be compiled for web. Navigate to its folder and run `tree-sitter build --wasm`. The first time you do, it will download necessary build files, which may take some time.

At first glance, the playground provides a similar output to the `parse` command, with the added convenience of being able to change the source document on the fly. But that's not all it can do.

With the "*show anonymous nodes*" option it becomes possible to view the AST of the source document with anonymous nodes included, which is crucial for understanding the node structure for building queries. And speaking of queries, the "*queries*" toggle brings into view a new panel where you can write queries and see the effect immediately through highlighting.

You can paste your entire `highlights.scm`, or any other query Scheme file, and view which parts of the document get captured by which rule. This is probably the most powerful way to debug queries.


## The query syntax

Let's revisit the example from the top.

```scm
(variable_statement
  name: (name) @variable)
```

This is a query that targets the `variable_statement` node. More specifically, it looks for a `variable_statement` node that has a `name` field. If that `name` field has a `name` node assigned to it, that node gets captured as `variable`.

In other words, within a variable statement find the name of the variable and mark it as `variable`. If this query is used in the `highlights.scm` file, and the `variable` capture is assigned a blue color in your Zed theme, then in the following document the word "my_var" will be highlighted in blue:

```gdscript
var my_var = 4
```

Every word used in this example is significant:
- `(variable_statement)` and `(name)` are node names from the parser grammar,
- `name:` is the name of the field of the `(variable_statement)` node,
- `@variable` is the name of a capture used in highlighting.

In principle, the name of the capture can be anything. As long as there is a matching syntax highlight color in the Zed theme that you use, it should work. Naturally, though, it's better to stick to the official list of colors to ensure maximum compatibility with all existing themes. (Though even officially supported languages in Zed deviate from that list a lot, and themes have to support those non-standard colors too.)

- [Zed documentation on syntax highlighting](https://zed.dev/docs/extensions/languages#syntax-highlighting)

The Tree-sitter query syntax is rather feature-rich, and the official documentation decently covers tools at your disposal:

- [Query basics](https://tree-sitter.github.io/tree-sitter/using-parsers/queries/1-syntax.html)
- [Operators](https://tree-sitter.github.io/tree-sitter/using-parsers/queries/2-operators.html)
- [Predicates and Directives](https://tree-sitter.github.io/tree-sitter/using-parsers/queries/3-predicates-and-directives.html)

Here are a couple of additional examples.

```scm
[
  "in"
  "out"
  "inout"
  (precision_qualifier)
  (interpolation_qualifier)
] @keyword.modifier
```

If the target node is either an anonymous `"in"`, `"out"`, `"inout"`, or a named `precision_qualifier`, `interpolation_qualifier`, mark it as `keyword.modifier`.

```scm
(
  "#" @keyword.preproc @preproc
  . ; Direct siblings only.
  "include" @keyword.preproc @preproc)
```

If there are two anonymous nodes, `"#"` and `"include"` that are right next to each other with no nodes in between, mark both of them as `keyword.preproc` and as `preproc`.
