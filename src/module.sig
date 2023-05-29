signature MODULE = sig
  include IDENT

  type module_name = ident
  type symbol_name = ident
  type module
  type menv

  val moduleName = module -> module_name
  val moduleExports = module -> symbol_name list
end
