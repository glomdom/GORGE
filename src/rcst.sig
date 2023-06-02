signature RCST = sig
  datatype rcst = IntConstant of int
                | StringConstant of CST.escaped_string
                | Symbol of Symbol.symbol
                | Keyword of Symbol.symbol_name
                | List of rcst list

  val resolve: Module.menv -> Module.module -> CST.cst -> rcst Util.result
end
