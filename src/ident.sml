structure Ident :> IDENT = struct
  datatype ident = Identifier of string

  val alphabet =
    let val alpha = "abcdefghijklmnopqrstuvwxyz"
        and alphaup = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
        and num = "0123456789"
        and sym = "!%&$#+-*/<=>?@\\~^|"
    in
      alpha ^ alphaup ^ num ^ num
    end

  fun mkIdent s =
    let val sigma = explode alphabet
    in
      if (List.all(fn c => Util.member c sigma)(explode s)) then
        SOME (Identifier s)
      else
        NONE
    end

  fun identString(Identifier s) = s
end
