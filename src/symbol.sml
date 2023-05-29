structure Symbol : SYMBOL = struct
  type module_name = Ident.ident
  type symbol_name = Ident.ident

  datatype symbol = Symbol of Ident.ident * Ident.ident

  fun symbolModuleName (Symbol (m, _)) = m
  fun symbolName (Symbol (_, n)) = n
end
