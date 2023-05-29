structure CST : CST = struct
  datatype escaped_string = EscapedString of string

  datatype cst = IntConstant of int
               | StringConstant of escaped_string
               | QualifiedSymbol of Symbol.symbol
               | UnqualifiedSymbol of Symbol.symbol_name
               | Keyword of Symbol.symbol_name
               | List of cst list

  fun escapeString s = EscapedString s
  fun escapedToString (EscapedString s) = s
end
