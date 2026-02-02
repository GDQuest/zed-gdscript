; Class
(class_name_statement (name) @type)
(class_definition (name) @type)


; Function calls

(attribute_call (identifier) @function)
(base_call (identifier) @function)
(call (identifier) @function)

; Function definitions

(function_definition
  name: (name) @function
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
] @comment.doc

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
[
  "PI"
  "TAU"
  "NAN"
  "INF"
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
(annotation (identifier) @keyword)

; Storage
[
  "var"
  "const"
  "signal"
  "enum"
  "static"
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
  "breakpoint"
  "yield"
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
  "export"
  "onready"
  "tool"
  "setget"
  "set"
  "get"
] @attribute

; Import
[
  "preload"
  "load"
] @keyword.import

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
