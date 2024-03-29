structure RCST :> RCST = struct
  datatype rcst = IntConstant of string
                | FloatConstant of string
                | StringConstant of CST.escaped_string
                | Symbol of Symbol.symbol
                | Keyword of Symbol.symbol_name
                | List of rcst list

  local
    open Symbol
  in
    fun resolveNicknames _ (CST.IntConstant i) = CST.IntConstant i
      | resolveNicknames _ (CST.FloatConstant f) = CST.FloatConstant f
      | resolveNicknames _ (CST.StringConstant s) = CST.StringConstant s
      | resolveNicknames m (CST.QualifiedSymbol s) = CST.QualifiedSymbol (resolveSymbol s m)
      | resolveNicknames _ (CST.UnqualifiedSymbol n) = CST.UnqualifiedSymbol n
      | resolveNicknames _ (CST.Keyword n) = CST.Keyword n
      | resolveNicknames m (CST.List l) = CST.List (map (resolveNicknames m) l)
    and resolveSymbol sym module =
      let val modName = symbolModuleName sym

      in
        mkSymbol (Module.resolveNickname module modName, symbolName sym)
      end
  end

  fun innResolve _ _ (CST.IntConstant i) = IntConstant i
    | innResolve _ _ (CST.FloatConstant f) = FloatConstant f
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
  and resolveUnqualified menv m (s: Symbol.symbol_name) = Symbol (Symbol.mkSymbol (Module.sourceModule menv m s, s))

  fun resolve menv m e =
    let val e' = resolveNicknames m e

    in
      Util.Result (innResolve menv m e') handle Fail msg => Util.Failure msg
    end
end
