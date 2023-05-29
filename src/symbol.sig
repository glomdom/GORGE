signature SYMBOL = sig
  type module_name
  type symbol_name

  type symbol

  val mkSymbol: module_name * symbol_name -> symbol
  val symbolModuleName: symbol -> module_name
  val symbolName: symbol -> symbol_name
end
