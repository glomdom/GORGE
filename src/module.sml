structure Module :> MODULE = struct
  open Symbol

  type nicknames = (module_name, module_name) Map.map

  datatype module = Module of module_name * nicknames * imports * exports
       and imports = Imports of (symbol_name, module_name) Map.map
       and exports = Exports of symbol_name Set.set

  datatype menv = MEnv of (module_name, module) Map.map

  fun moduleName (Module (n, _, _, _)) = n
  fun moduleExports (Module (_, _, _, Exports e)) = e
  fun moduleImports (Module (_, _, Imports i, _)) = i

  fun sourceModule m s =
    case (Map.get (moduleImports m) s) of
        SOME n => n
      | NONE => moduleName m

  fun doesModuleExport (m: module) (s: symbol_name) =
    Set.isIn (moduleExports m) s
end
