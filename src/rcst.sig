signature RCST = sig
  datatype rcst = IntConstant of string
                | FloatConstant of string
                | StringConstant of CST.escaped_string
                | Symbol of Symbol.symbol
                | Keyword of Symbol.symbol_name
                | List of rcst list

  val resolveNicknames: Module.module -> CST.cst -> CST.cst
  val resolve: Module.menv -> Module.module -> CST.cst -> rcst Util.result
end
