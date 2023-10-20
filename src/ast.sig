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

  type name = Symbol.symbol
  type docstring = string option
  type symbol = Symbol.symbol
  type typespec = Type.typespec

  datatype top_ast = Defun of name * param list * typespec * docstring * ast
                   | Defclass of name * symbol * docstring * method list
                   | Definstance of name * typespec * docstring * method_def list
                   | Deftype of name * Type.param list * typespec * docstring
                   | Defdisjunction of name * Type.param list * disjunction_case list * docstring
                   | Defmacro
                   | DefineSymbolMacro of name * RCST.rcst * docstring
                   | Defmodule of Module.module
                   | InModule of Symbol.symbol_name
    and param = Param of name * typespec
    and method = Method of name * param list * typespec * docstring
    and method_def = MethodDef of name * param list * typespec * docstring * ast
    and disjunction_case = DisjCase of name * typespec option

  val transform: RCST.rcst -> ast
end
