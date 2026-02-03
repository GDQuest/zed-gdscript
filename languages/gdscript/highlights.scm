; Class
(class_name_statement (name) @type)
(class_definition (name) @type)


; Function calls

(attribute_call (identifier) @function.method)
(base_call (identifier) @function.builtin)
(call (identifier) @function)

; Function definitions

(function_definition
  name: (name) @function.definition
  parameters: (parameters) @variable.parameter)
(constructor_definition "_init" @function)
(lambda (parameters) @variable.parameter)


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

(type) @type
(enum_definition (name) @type)
(enumerator (identifier) @variant)

(variable_statement (identifier) @variable)
(attribute
  (identifier)
  (identifier) @property)

((identifier) @type
  (#match? @type "^(bool|float|int)$"))

[
  (string_name)
  (node_path)
  (get_node)
] @label
(signal_statement (name) @label)

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

((identifier) @keyword
  (#match? @keyword "^(self|super)$"))

; Identifier naming conventions
; This needs to be at the very end in order to override earlier queries

; Mark identifiers that start with a capital letter as types
(
  (identifier) @type
  (#match? @type "^[A-Z]+"))

(
  (identifier) @constant
  (#match? @constant "^[A-Z][A-Z\\d_]+$"))
