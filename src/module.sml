structure Module :> MODULE = struct
  type module_name = Ident.ident
  type symbol_name = Ident.ident

  datatype module = Module of module_name * imports * exports
       and imports = Imports of (symbol_name, module_name) Map.map
       and exports = Exports of symbol_name Set.set
  
  datatype menv = MEnv of (module_name, module) Map.map

  fun moduleName (Module (n, _, _)) = n
  fun moduleExports (Module (_, _, Exports e)) = e
  fun moduleImports (Module (_, Imports i, _)) = i

  fun sourceModule m s =
    case (Map.get (moduleImports m) s) of
        SOME n => n
      | NONE => moduleName m

  fun doesModuleExport (m: module) (s: symbol_name) =
    Set.isIn (moduleExports m) s
end
