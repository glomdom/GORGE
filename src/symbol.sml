structure Symbol :> SYMBOL = struct 
  datatype symbol = Symbol of Ident.ident * Ident.ident
end
