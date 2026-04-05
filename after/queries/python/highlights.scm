; From tree-sitter-python licensed under MIT License

; Identifier naming conventions

((identifier) @type
  (#lua-match? @type "^[A-Z].*[a-z]"))

((identifier) @constant
  (#lua-match? @constant "^[A-Z][A-Z_0-9]*$"))

((identifier) @constant.builtin
  (#any-of? @constant.builtin "NotImplemented" "Ellipsis"))

; Function calls

(call
  function: (identifier) @function.call)

(call
  function: (attribute
    attribute: (identifier) @function.method.call))

((call
  function: (identifier) @constructor)
  (#lua-match? @constructor "^[A-Z]"))

((call
  function: (attribute
    attribute: (identifier) @constructor))
  (#lua-match? @constructor "^[A-Z]"))

; Builtin functions

((call
  function: (identifier) @function.builtin)
  (#any-of? @function.builtin
    "abs" "all" "any" "ascii" "bin" "bool" "breakpoint" "bytearray" "bytes" "callable" "chr"
    "classmethod" "compile" "complex" "delattr" "dict" "dir" "divmod" "enumerate" "eval" "exec"
    "filter" "float" "format" "frozenset" "getattr" "globals" "hasattr" "hash" "help" "hex" "id"
    "input" "int" "isinstance" "issubclass" "iter" "len" "list" "locals" "map" "max"
    "memoryview" "min" "next" "object" "oct" "open" "ord" "pow" "print" "property" "range"
    "repr" "reversed" "round" "set" "setattr" "slice" "sorted" "staticmethod" "str" "sum"
    "super" "tuple" "type" "vars" "zip" "__import__"))

; Function definitions

(function_definition
  name: (identifier) @function)

(type
  (identifier) @type)

(type
  (subscript
    (identifier) @type)) ; type subscript: Tuple[int]

((call
  function: (identifier) @_isinstance
  arguments: (argument_list
    (_)
    (identifier) @type))
  (#eq? @_isinstance "isinstance"))

; Builtin types

((identifier) @type.builtin
  (#any-of? @type.builtin
    "bool" "bytes" "complex" "dict" "float" "frozenset" "int" "list" "memoryview" "object"
    "range" "set" "slice" "str" "tuple"))

; Decorators

((decorator "@" @attribute)
  (#set! "priority" 101))

(decorator
  (identifier) @attribute)

(decorator
  (attribute
    attribute: (identifier) @attribute))

(decorator
  (call
    (identifier) @attribute))

(decorator
  (call
    (attribute
      attribute: (identifier) @attribute)))

((decorator
  (identifier) @attribute.builtin)
  (#any-of? @attribute.builtin "classmethod" "property" "staticmethod"))

; Class definitions

(class_definition
  name: (identifier) @type)

(class_definition
  body: (block
    (function_definition
      name: (identifier) @function.method)))

(class_definition
  superclasses: (argument_list
    (identifier) @type))

((class_definition
  body: (block
    (expression_statement
      (assignment
        left: (identifier) @variable.member))))
  (#lua-match? @variable.member "^[%l_].*$"))

((class_definition
  body: (block
    (expression_statement
      (assignment
        left: (_
          (identifier) @variable.member)))))
  (#lua-match? @variable.member "^[%l_].*$"))

; Method definitions

((function_definition
  name: (identifier) @constructor)
  (#any-of? @constructor "__new__" "__init__"))

; Function arguments

(parameters
  (identifier) @variable.parameter)

(parameters
  (typed_parameter
    (identifier) @variable.parameter))

(parameters
  (default_parameter
    name: (identifier) @variable.parameter))

(parameters
  (typed_default_parameter
    name: (identifier) @variable.parameter))

(parameters
  (list_splat_pattern
    (identifier) @variable.parameter))

(parameters
  (dictionary_splat_pattern
    (identifier) @variable.parameter))

(lambda_parameters
  (identifier) @variable.parameter)

((identifier) @variable.parameter.builtin
  (#any-of? @variable.parameter.builtin "self" "cls"))

; Keyword arguments

(keyword_argument
  name: (identifier) @variable.parameter)

; Attributes

(attribute
  attribute: (identifier) @variable.member)

; Imports

(import_statement
  name: (dotted_name
    (identifier) @module))

(import_statement
  name: (aliased_import
    name: (dotted_name
      (identifier) @module)
    alias: (identifier) @module))

(import_from_statement
  module_name: (dotted_name
    (identifier) @module))

(import_from_statement
  module_name: (relative_import
    (dotted_name
      (identifier) @module)))

(import_from_statement
  name: (dotted_name
    (identifier) @type))

(import_from_statement
  name: (aliased_import
    name: (dotted_name
      (identifier) @type)
    alias: (identifier) @type))

; Literals

[
  (none)
] @constant.builtin

[
  (true)
  (false)
] @boolean

((identifier) @variable.builtin
  (#any-of? @variable.builtin "self" "cls"))

((identifier) @variable.builtin
  (#eq? @variable.builtin "__debug__"))

[
  (integer)
] @number

[
  (float)
] @number.float

(comment) @comment @spell

(string) @string

(string_start) @string
(string_content) @string
(string_end) @string

(escape_sequence) @string.escape

; Interpolations

(interpolation
  "{" @punctuation.special
  "}" @punctuation.special) @none

(interpolation
  (type_conversion) @function.macro)

(interpolation
  (format_specifier) @string.special)

; Format specifier

(format_specifier) @string.special

; Keywords

[
  "-"
  "-="
  ":="
  "!="
  "*"
  "**"
  "**="
  "*="
  "/"
  "//"
  "//="
  "/="
  "&"
  "&="
  "%"
  "%="
  "^"
  "^="
  "+"
  "+="
  "<"
  "<<"
  "<<="
  "<="
  "<>"
  "="
  "=="
  ">"
  ">="
  ">>"
  ">>="
  "@"
  "@="
  "|"
  "|="
  "~"
  "->"
] @operator

[
  "and"
  "in"
  "is"
  "not"
  "or"
  "is not"
  "not in"
  "del"
] @keyword.operator

[
  "def"
  "lambda"
] @keyword.function

[
  "assert"
  "class"
  "exec"
  "global"
  "nonlocal"
  "pass"
  "print"
  "with"
  "as"
] @keyword

[
  "async"
  "await"
] @keyword.coroutine

[
  "return"
  "yield"
] @keyword.return

(yield "from" @keyword.return)

(future_import_statement
  "from" @keyword.import
  "__future__" @module.builtin)

(import_from_statement
  "from" @keyword.import)

[
  "import"
] @keyword.import

[
  "if"
  "elif"
  "else"
  "match"
  "case"
] @keyword.conditional

(conditional_expression [ "if" "else" ] @keyword.conditional.ternary)

[
  "for"
  "while"
  "break"
  "continue"
] @keyword.repeat

[
  "try"
  "except"
  "raise"
  "finally"
] @keyword.exception

[
  (ellipsis)
] @constant.builtin

; Punctuation

[ "(" ")" "[" "]" "{" "}" ] @punctuation.bracket

[
  ","
  "."
  ":"
  ";"
  "->"
] @punctuation.delimiter

; Error

(ERROR) @error
