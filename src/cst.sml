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
    | escapeList (#"\\" :: #"r" :: rest) = #"\r" :: (escapeList rest)
    | escapeList (#"\\" :: #"t" :: rest) = #"\t" :: (escapeList rest)
    | escapeList (#"\\" :: #"\"" :: rest) = #"\"" :: (escapeList rest)
    | escapeList (#"\\" :: #"\\" :: rest) = #"\\" :: (escapeList rest)
    | escapeList (#"\\" :: #" " :: rest) = consumeWhitespace (#" " :: rest)
    | escapeList (#"\\" :: #"\n" :: rest) = consumeWhitespace (#" " :: rest)
    | escapeList (#"\\" :: #"\r" :: rest) = consumeWhitespace (#" " :: rest)
    | escapeList (#"\\" :: #"\t" :: rest) = consumeWhitespace (#" " :: rest)
    | escapeList (#"\\" :: #"\v" :: rest) = consumeWhitespace (#" " :: rest)
    | escapeList (#"\\" :: #"\f" :: rest) = consumeWhitespace (#" " :: rest)
    | escapeList (head :: rest) = head :: (escapeList rest)
    | escapeList nil = nil
  and consumeWhitespace (#" "  :: rest) = consumeWhitespace rest
    | consumeWhitespace (#"\n" :: rest) = consumeWhitespace rest
    | consumeWhitespace (#"\r" :: rest) = consumeWhitespace rest
    | consumeWhitespace (#"\t" :: rest) = consumeWhitespace rest
    | consumeWhitespace (#"\v" :: rest) = consumeWhitespace rest
    | consumeWhitespace (#"\f" :: rest) = consumeWhitespace rest
    | consumeWhitespace (#"\\" :: rest) = rest
    | consumeWhitespace _ = raise Fail "bad whitespace escape sequence"

  fun escapedToString (EscapedString s) = s
end
