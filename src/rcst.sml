structure RCST :> RCST = struct
  datatype rcst = IntConstant of int
                | StringConstant of CST.escaped_string
                | Symbol of Symbol.symbol
                | Keyword of Symbol.symbol_name
                | List of rcst list

  fun innResolve _ _ (CST.IntConstant i) = IntConstant i
    | innResolve _ _ (CST.StringConstant es) = StringConstant es
    | innResolve menv m (CST.QualifiedSymbol s) = resolveQualified menv m (Symbol.symbolModuleName s) (Symbol.symbolName s)
    | innResolve menv m (CST.UnqualifiedSymbol s) = resolveUnqualified menv m s
    | innResolve _ _ (CST.Keyword n) = Keyword n
    | innResolve menv m (CST.List l) = List (map (fn e => innResolve menv m e) l)
  and resolveQualified menv module (mn: Symbol.module_name) (sn: Symbol.symbol_name) =
    let val truename = Module.resolveNickname module mn

    in
      case (Module.envGet menv truename) of
          SOME formod => if Module.doesModuleExport formod sn then Symbol (Symbol.mkSymbol (Module.moduleName formod, sn)) else raise Fail ("module `" ^ (Ident.identString truename) ^ "` does not export symbol `" ^ (Ident.identString sn) ^ "`")
                           
        | NONE => raise Fail ("no module name `" ^ (Ident.identString truename) ^ "`")
    end

  and resolveUnqualified _ m (s: Symbol.symbol_name) = Symbol (Symbol.mkSymbol (Module.sourceModule m s, s))

  fun resolve menv m e = Util.Result (innResolve menv m e) handle Fail msg => Util.Failure msg
end
