; Any uncovered text,
; var a = 10 has 'a' matching @variable
; but a = 10 has 'a matching nothing.
; This is to keep consistency, and is like 'text_editor/theme/highlighting/text_color' in Godot Editor Settings
(identifier) @variable


; Class
(class_name_statement (name) @type)
(class_definition (name) @type)


; Function calls
(attribute_call (identifier) @function.method)
(base_call (identifier) @function.builtin)
(call (identifier) @function)

; Function definitions
(function_definition
  name: (name) @function.definition)
; Constructor definition
(function_definition
    name: (name) @constructor
    (#eq? @constructor "_init"))
; Untyped function parameter defintiion: a in func foo(a)
(parameters (identifier) @variable.parameter)
; Typed function parameter defition: b in func foo(b: int)
(parameters
  (typed_parameter
    . (identifier) @variable.parameter))
; both of the above work with lambdas too!

;; Literals
(comment) @comment
((comment) @comment.doc
  (#match? @comment.doc "^##"))
[
  (region_start)
  (region_end)
] @tag

; Critical comment
((comment) @error
    (#match? @error "\\b(ALERT|ATTENTION|CAUTION|CRITICAL|DANGER|SECURITY)\\b"))

; Warning comment
((comment) @warning
    (#match? @warning "\\b(BUG|DEPRECATED|FIXME|HACK|TASK|TBD|TODO|WARNING)\\b"))

; Info comment
((comment) @info
    (#match? @info "\\b(INFO|NOTE|NOTICE|TEST|TESTING)\\b"))

(string) @string

; currently no differentiation between built-in types (int, Vector2), and custom ones (with class_name)
(type) @type
(enum_definition (name) @type)
(enumerator (identifier) @variant)

; Catch the name in a 'var' declaration
(variable_statement
  name: (name) @variable)

; Catch the name in a 'var' declaration with a type hint (like dirs: Dictionary)
(variable_statement
  name: (name) @variable
  type: (type))
(attribute
  (identifier)
  (identifier) @property)

((identifier) @type
  (#match? @type "^(bool|float|int)$"))

(string_name) @string.special.symbol
(node_path) @string.special.path
(get_node) @string.special
(signal_statement (name) @variable.special)

(const_statement (name) @constant)

[
  (integer)
  (float)
] @number

(escape_sequence) @string.escape

((identifier) @constant.builtin
    (#match? @constant.builtin "^(PI|TAU|NAN|INF)$"))
[
  (null)
  (true)
  (false)
] @constant.builtin

[
  "+"
  "-"
  "*"
  "**"
  "/"
  "%"
  "=="
  "!="
  ">"
  "<"
  ">="
  "<="
  "&&"
  "||"
  "="
  "+="
  "-="
  "*="
  "/="
  "%="
  "&="
  "^="
  "|="
  "&"
  "|"
  "^"
  "~"
  "<<"
  ">>"
  ":="
  "<<="
  ">>="
  "**="
  ":" ; for consistency (to make :type= same as :=)
] @operator

; Keywords

; Annotations
(annotation (identifier) @attribute)

; Storage
[
  "var"
  "const"
  "signal"
  "enum"
  (static_keyword)
] @keyword.storage

; Function
"func" @keyword.function

; Action
[
  "if"
  "else"
  "elif"
  "match"
  "while"
  "for"
  "return"
  "break"
  "continue"
  "await"
  "pass"
  (breakpoint_statement)
] @keyword.control

; Operator
[
  "and"
  "or"
  "not"
  "in"
  "is"
  "as"
] @keyword.operator

; Attribute
[
  "@"
  ; "export" covered in Annotations above (@ followed by anything)
  ; "onready"
  "setget"
  "set"
  "get"
] @attribute

; Import
((identifier) @keyword.import
    (#match? @keyword.import "^(load|preload)$"))

; Remaining Keywords
[
  "class"
  "class_name"
  "extends"
] @keyword

((identifier) @variable.language
  (#match? @variable.language "^(self|super)$"))

; Identifier naming conventions
; This needs to be at the very end in order to override earlier queries

; Mark identifiers that start with a capital letter as types
(
  (identifier) @type
  (#match? @type "^[A-Z]+"))

(
  (identifier) @constant
  (#match? @constant "^[A-Z][A-Z\\d_]+$"))
