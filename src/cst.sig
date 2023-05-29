signature CST = sig
  datatype cst = IntConstant of int
               | StringConstant of string
               | QualifiedSymbol of Symbol.symbol
               | UnqualifiedSymbol of Symbol.symbol_name
               | Keyword of Module.symbol_name
               | List of cst list
end
