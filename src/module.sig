signature MODULE = sig
  include SYMBOL

  type nicknames = (module_name, module_name) Map.map
  datatype imports = Imports of (symbol_name, module_name) Map.map
  datatype exports = Exports of symbol_name Set.set
  datatype module = Module of module_name * nicknames * imports * exports
  type menv

  val moduleName: module -> module_name
  val moduleExports: module -> symbol_name Set.set
  val moduleImports: module -> (symbol_name, module_name) Map.map

  val emptyEnv: menv
  val addModule: menv -> module -> menv
  val envGet: menv -> module_name -> module option

  val resolveNickname: module -> module_name -> module_name
  val sourceModule: module -> symbol_name -> module_name
  val doesModuleExport: module -> symbol_name -> bool
end
