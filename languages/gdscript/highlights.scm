; Any uncovered text,
; var a = 10 has 'a' matching @variable
; but a = 10 has 'a matching nothing.
; This is to keep consistency, and is like 'text_editor/theme/highlighting/text_color' in Godot Editor Settings
(identifier) @variable
; Self reference in class.
((identifier) @variable.builtin
  (#eq? @variable.builtin "self"))


; Class
(class_name_statement (name) @type)
(class_definition (name) @type)


; Function calls
(attribute_call (identifier) @function.method)
(base_call (identifier) @function.method)
(call (identifier) @function)

; Global built-in functions from @GlobalScope and @GDScript.
((call (identifier) @function @function.builtin)
  (#any-of? @function.builtin
    "Color8"
    "abs"
    "absf"
    "absi"
    "acos"
    "acosh"
    "angle_difference"
    "asin"
    "asinh"
    "assert"
    "atan"
    "atan2"
    "atanh"
    "bezier_derivative"
    "bezier_interpolate"
    "bytes_to_var"
    "bytes_to_var_with_objects"
    "ceil"
    "ceilf"
    "ceili"
    "char"
    "clamp"
    "clampf"
    "clampi"
    "convert"
    "cos"
    "cosh"
    "cubic_interpolate"
    "cubic_interpolate_angle"
    "cubic_interpolate_angle_in_time"
    "cubic_interpolate_in_time"
    "db_to_linear"
    "deg_to_rad"
    "dict_to_inst"
    "ease"
    "error_string"
    "exp"
    "floor"
    "floorf"
    "floori"
    "fmod"
    "fposmod"
    "get_stack"
    "hash"
    "inst_to_dict"
    "instance_from_id"
    "inverse_lerp"
    "is_equal_approx"
    "is_finite"
    "is_inf"
    "is_instance_id_valid"
    "is_instance_of"
    "is_instance_valid"
    "is_nan"
    "is_same"
    "is_zero_approx"
    "len"
    "lerp"
    "lerp_angle"
    "lerpf"
    "linear_to_db"
    "log"
    "max"
    "maxf"
    "maxi"
    "min"
    "minf"
    "mini"
    "move_toward"
    "nearest_po2"
    "ord"
    "pingpong"
    "posmod"
    "pow"
    "print"
    "print_debug"
    "print_rich"
    "print_stack"
    "print_verbose"
    "printerr"
    "printraw"
    "prints"
    "printt"
    "push_error"
    "push_warning"
    "rad_to_deg"
    "rand_from_seed"
    "randf"
    "randf_range"
    "randfn"
    "randi"
    "randi_range"
    "randomize"
    "range"
    "remap"
    "rid_allocate_id"
    "rid_from_int64"
    "rotate_toward"
    "round"
    "roundf"
    "roundi"
    "seed"
    "sign"
    "signf"
    "signi"
    "sin"
    "sinh"
    "smoothstep"
    "snapped"
    "snappedf"
    "snappedi"
    "sqrt"
    "step_decimals"
    "str"
    "str_to_var"
    "tan"
    "tanh"
    "type_convert"
    "type_exists"
    "type_string"
    "typeof"
    "var_to_bytes"
    "var_to_bytes_with_objects"
    "var_to_str"
    "weakref"
    "wrap"
    "wrapf"
    "wrapi"))
; Super calls have two forms:
; - super() to call this method's parent implementation,
; - super.other() to call another method's parent implementation.
((identifier) @function.builtin
    (#eq? @function.builtin "super"))
(call (identifier) @function.builtin
    (#eq? @function.builtin "super"))


; Setget
(setget
    get: (getter) @function.method)
(setget
    set: (setter) @function.method)

; Function definitions
(function_definition
  name: (name) @function.definition)
; Constructor definition (tree-sitter doesn't return a name capture for it)
(constructor_definition
    "_init" @constructor)
; Constructor definition fallback (when tree-sitter doesn't report it correctly, e.g. in inner classes).
(function_definition
    name: (name) @constructor
    (#eq? @constructor "_init"))
; Untyped function parameter definition: a in func foo(a)
(parameters (identifier) @variable.parameter)
; Typed function parameter definition: b in func foo(b: int)
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

; Control flow
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

; Identifier naming conventions
; This needs to be at the very end in order to override earlier queries

; Mark identifiers that start with a capital letter as types
(
  (identifier) @type
  (#match? @type "^[A-Z]+"))

(
  (identifier) @constant
  (#match? @constant "^[A-Z][A-Z\\d_]+$"))
