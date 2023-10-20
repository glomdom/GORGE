structure AST :> AST = struct
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
                   | Definstance
                   | Deftype of name * Type.param list * typespec * docstring
                   | Defdisjunction of name * Type.param list * disjunction_case list * docstring
                   | Defmacro
                   | DefineSymbolMacro of name * RCST.rcst * docstring
                   | Defmodule of Module.module
                   | InModule of Symbol.symbol_name
    and param = Param of name * typespec
    and method = Method of name * param list * typespec * docstring
    and disjunction_case = DisjCase of name * typespec option

  fun gorge name = Symbol.mkSymbol (Ident.mkIdentEx "gorge", Ident.mkIdentEx name)

  val theOp = gorge "the"

  fun transform (RCST.IntConstant i) = IntConstant i
    | transform (RCST.FloatConstant f) = FloatConstant f
    | transform (RCST.StringConstant s) = StringConstant s
    | transform (RCST.Symbol s) = Symbol s
    | transform (RCST.Keyword s) = Keyword s
    | transform (RCST.List l) = transformList l
  and transformList ((RCST.Symbol theOp)::ty::exp::nil) = The (ty, transform exp)
    | transformList ((RCST.Symbol f)::rest) = Operator (f, map transform rest)
    | transformList _ = raise Fail "invalid form"
end
