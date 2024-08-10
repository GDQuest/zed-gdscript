(class_definition
    "class" @context
    name: (_) @name) @item

(function_definition
    "func" @context
    name: (_) @name) @item

(const_statement
    "const" @context
    name: (_) @name) @item

(signal_statement
    "signal" @context
    (name) @name) @item

; Annotated variables use sibling nodes to store the annotation
; TODO: find a way to capture the annotation in the outline to distinguish
; annotated variables from regular variables
(_
  (annotation) @context
  (variable_statement
    "var" @context
    name: (_) @name
  )
) @item

(variable_statement
    "var" @context
    name: (_) @name
) @item

(enum_definition
    "enum" @context
    name: (_) @name) @item
