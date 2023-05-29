signature MODULE = sig
  include SYMBOL

  type module
  type menv

  val moduleName: module -> module_name
  val moduleExports: module -> symbol_name Set.set
  val moduleImports: module -> (symbol_name, module_name) Map.map

  val sourceModule: module -> symbol_name -> module_name
  val doesModuleExport: module -> symbol_name -> bool
end
