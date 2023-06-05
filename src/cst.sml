structure CST : CST = struct
  datatype escaped_string = EscapedString of string

  datatype cst = IntConstant of string
               | FloatConstant of string
               | StringConstant of escaped_string
               | QualifiedSymbol of Symbol.symbol
               | UnqualifiedSymbol of Symbol.symbol_name
               | Keyword of Symbol.symbol_name
               | List of cst list

  fun escapeString s =
    EscapedString (String.implode (escapeList (String.explode s)))
  and escapeList (#"\\" :: #"n" :: rest) = #"\n" :: (escapeList rest)
    | escapeList (head :: rest) = head :: (escapeList rest)
    | escapeList nil = nil

  fun escapedToString (EscapedString s) = s
end
