signature MODULE = sig
  type module_name = Ident.ident
  type symbol_name = Ident.ident
  type module
  type menv

  val moduleName: module -> module_name
  val moduleExports: module -> symbol_name Set.set
  val moduleImports: module -> (symbol_name, module_name) Map.map

  val doesModuleExport: module -> symbol_name -> bool
end
