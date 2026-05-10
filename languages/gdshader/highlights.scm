; Made using highlights done for nvim-treesitter as a base
; https://github.com/nvim-treesitter/nvim-treesitter/blob/42fc28ba918343ebfd5565147a42a26580579482/queries/gdshader/highlights.scm

; Keywords
[
  "shader_type"
  "render_mode"
  "group_uniforms"
  "uniform"
  "varying"
  "global"
  "instance"
  "const"
  "struct"
] @keyword

[
  (shader_type)
  (render_mode)
  (hint_name)
] @attribute

; Modifiers
[
  "in"
  "out"
  "inout"
  (precision_qualifier)
  (interpolation_qualifier)
] @keyword.modifier

; Control flow
[
  ; repeat
  "while"
  "for"
  ; return
  "continue"
  "break"
  "return"
  ; conditional
  "if"
  "else"
  "switch"
  "case"
  "default"
] @keyword.control

; Operators
[
  "="
  "+="
  "-="
  "!"
  "~"
  "+"
  "-"
  "*"
  "/"
  "%"
  "||"
  "&&"
  "|"
  "^"
  "&"
  "=="
  "!="
  ">"
  ">="
  "<="
  "<"
  "<<"
  ">>"
  "++"
  "--"
] @operator

; Preprocessor
; Preprocessor words cannot be targetted completely because the parser
; errs around many of them, or just doesn't recognize them as valid nodes.
; Related to that, we can also not match "defined" well, since it detects
; as a function call (in an invalid context).
; Also not that the "#" symbol is NOT a part of the node, it's a separate
; node even when matched correctly. E.g. `#include` parsed into "#" and
; "include".
(
  "#" @keyword.preproc @preproc
  . ; Direct siblings only.
  [
    ;"define"
    ;"undef"
    ;"ifdef"
    ;"ifndef"
    "if"
    "elif"
    "else"
    ;"endif"
    ;"error"
    "include"
    ;"pragma"
  ] @keyword.preproc @preproc)
; Explicitly match inside errors, because they don't match above.
(ERROR
  (
    "#" @keyword.preproc @preproc
    . ; Direct siblings only.
    [
        ;"define"
        ;"undef"
        ;"ifdef"
        ;"ifndef"
        "if"
        "elif"
        "else"
        ;"endif"
        ;"error"
        "include"
        ;"pragma"
    ] @keyword.preproc @preproc))

;"defined" @keyword.preproc @preproc

; As a temporary solution we highlight "#" individually, so there is at
; least something.
"#" @keyword.preproc @preproc

; Delimiters
[
  "."
  ","
  ";"
] @punctuation.delimiter

[
  "("
  ")"
  "["
  "]"
  "{"
  "}"
] @punctuation.bracket

; Comments
(comment) @comment

; Built-in types
(boolean) @boolean
[
  (integer)
  (float)
] @number
(string) @string

(builtin_type) @type.builtin
(builtin_variable) @constant.builtin
(builtin_function) @function.builtin

; User declarations

(ident) @variable
(ident_type) @type

(group_uniforms_declaration
  group_name: (ident) @attribute)
(group_uniforms_declaration
  group_name: (ident) @attribute
  subgroup_name: (ident) @attribute)

(struct_declaration
  name: (ident) @type)

(struct_member
  name: (ident) @property)

(const_declaration
  specifier: (var_specifier
    name: (ident) @constant))
(uniform_declaration
  specifier: (var_specifier
    name: (ident) @property))
(varying_declaration
  specifier: (var_specifier
    name: (ident) @property))

(function_declaration
  name: (ident) @function)

(parameter
  name: (ident) @variable.parameter)

(member_expr
  member: (ident) @property)

(call_expr
  function: (ident) @function)

; Not actually a function call, but rather a type constructor/literal.
(call_expr
  function: (builtin_type) @type.builtin)
