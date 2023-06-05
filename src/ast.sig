signature AST = sig
  datatype ast = IntConstant of string
                   | FloatConstant of string
                   | StringConstant of CST.escaped_string
                   | Symbol of Symbol.symbol
                   | Keyword of Symbol.symbol_name
                   | Let of binding list * ast
                   | The of RCST.rcst * ast
                   | Operator of Symbol.symbol * ast list
       and binding = Binding of Symbol.symbol * ast

  type docstring = string option
  datatype top_ast = Defun
                   | Defclass
                   | Definstance
                   | Deftype
                   | Defdisjunction
                   | Defmacro
                   | DefineSymbolMacro of Symbol.symbol * RCST.rcst * docstring
                   | Defmodule
                   | InModule of Symbol.symbol_name

  val transform: RCST.rcst -> ast
end
