signature RCST = sig
  datatype rcst = IntConstant of int
                | StringConstant of string
                | Symbol of Symbol.symbol
                | Keyword of Module.symbol_name
                | List of rcst list

  val resolve: Module.menv -> Module.module -> CST.cst -> rcst
end
