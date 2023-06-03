structure AST :> AST = struct
  datatype exp_ast = IntConstant of string
                   | FloatConstant of string
                   | StringConstant of CST.escaped_string
                   | Symbol of Symbol.symbol
                   | Operator of Symbol.symbol * exp_ast list
end
