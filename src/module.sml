structure Module : MODULE = struct
  open Symbol

  type nicknames = (module_name, module_name) Map.map
  datatype imports = Imports of (symbol_name, module_name) Map.map
  datatype exports = Exports of symbol_name Set.set

  datatype module = Module of module_name * nicknames * imports * exports
  datatype menv = MEnv of (module_name, module) Map.map

  fun moduleName (Module (n, _, _, _)) = n
  fun moduleNicknames (Module (_, ns, _, _)) = ns
  fun moduleExports (Module (_, _, _, Exports e)) = e
  fun moduleImports (Module (_, _, Imports i, _)) = i

  val emptyEnv = MEnv (Map.empty)
  fun envGet (MEnv map) n = Map.get map n

  fun addModule (MEnv map) m =
    MEnv (Map.iadd map (moduleName m, m))

  fun resolveNickname (m: module) (n: module_name) =
    case Map.get (moduleNicknames m) n of
        SOME n => n
      | NONE => n

  fun sourceModule menv m s =
    case (Map.get (moduleImports m) s) of
        SOME modName => (case (envGet menv modName) of
            SOME sourceMod => sourceModule menv sourceMod s
          | NONE => raise Fail "module not found in menv")
      | NONE => moduleName m

  fun doesModuleExport (m: module) (s: symbol_name) =
    Set.isIn (moduleExports m) s
end
