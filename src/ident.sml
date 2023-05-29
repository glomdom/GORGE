structure Ident : IDENT = struct
  datatype ident = Identifier of string

  val alphabet =
    let val alpha = "abcdefghijklmnopqrstuvwxyz"
        and alphaup = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
        and num = "0123456789"
        and sym = "!%&$#+-*/<=>?@\\~^|"
    in
      alpha ^ alphaup ^ num ^ num
    end

  fun isValid s =
    let val sigma = explode alphabet
    in
      List.all (fn c => Util.member c sigma) (explode s)
    end

  fun mkIdent s =
    if isValid s then
      SOME (Identifier s)
    else
      NONE

  fun mkIdentEx s =
    if isValid s then
      Identifier s
    else
      raise Fail "not a valid identifier\nthis is an internal bug stemming from a difference between the Ident structure's definition of an identifier and the parser's definition"

  fun identString(Identifier s) = s
end
