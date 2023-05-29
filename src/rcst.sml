structure RCST :> RCST = struct
  datatype rcst = IntConstant of int
                | StringConstant of CST.escaped_string
                | Symbol of Symbol.symbol
                | Keyword of Symbol.symbol_name
                | List of rcst list

  fun resolve _ _ (CST.IntConstant i) = IntConstant i
    | resolve _ _ (CST.StringConstant es) = StringConstant es
    | resolve _ _ _ = raise Fail "NOT IMPLEMENTED"
end
