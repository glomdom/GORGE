signature CST = sig
  type escaped_string

  datatype cst = IntConstant of int
               | StringConstant of escaped_string
               | QualifiedSymbol of Symbol.symbol
               | UnqualifiedSymbol of Symbol.symbol_name
               | Keyword of Module.symbol_name
               | List of cst list

  val escapeString: string -> escaped_string
  val escapedToString: escaped_string -> string
end
