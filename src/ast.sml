structure AST :> AST = struct
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
