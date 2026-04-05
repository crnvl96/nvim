(decorated_definition
  (function_definition)) @function.outer

(function_definition
  body: (block)? @function.inner) @function.outer
