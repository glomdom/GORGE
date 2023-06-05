signature AST = sig
  datatype exp_ast = IntConstant of string
                   | FloatConstant of string
                   | StringConstant of CST.escaped_string
                   | Symbol of Symbol.symbol
                   | Let of binding list * exp_ast
                   | The of RCST.rcst * exp_ast
                   | Operator of Symbol.symbol * exp_ast list
       and binding = Binding of Symbol.symbol * exp_ast
end
