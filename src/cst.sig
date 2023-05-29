signature CST = sig
  datatype cst = IntConstant of int
               | StringConstant of string
               | QualifiedSymbol of Module.module_name * Module.symbol_name
               | UnqualifiedSymbol of Module.symbol_name
               | Keyword of Module.symbol_name
               | List of cst list
end
