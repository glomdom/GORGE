signature AST = sig
  datatype ast = IntConstant of string
               | FloatConstant of string
               | StringConstant of CST.escaped_string
               | Symbol of Symbol.symbol
               | Keyword of Symbol.symbol_name
               | Let of binding * ast
               | The of RCST.rcst * ast
               | Operator of Symbol.symbol * ast list
       and binding = Binding of Symbol.symbol * ast

  type docstring = string option
  datatype top_ast = Defun of Symbol.symbol * param list * Type.typespec * docstring * ast
                   | Defclass
                   | Definstance
                   | Deftype of Symbol.symbol * Type.param list * Type.typespec * docstring
                   | Defdisjunction
                   | Defmacro
                   | DefineSymbolMacro of Symbol.symbol * RCST.rcst * docstring
                   | Defmodule of Module.module
                   | InModule of Symbol.symbol_name
         and param = DefunParam of Symbol.symbol * Type.typespec

  val transform: RCST.rcst -> ast
end
