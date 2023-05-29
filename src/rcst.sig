signature RCST = sig
  datatype rcst = IntConstant of int
                | StringConstant of string
                | Symbol of Module.module_name * Module.symbol_name
                | Keyword of Module.symbol_name
                | List of rcst list
end
