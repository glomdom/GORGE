structure Parser :> PARSER = struct
  structure ps = Parsimony(ParsimonyStringInput)
  open ps

  (* Integers *)
  val digitParser = anyOf [#"0", #"1", #"2", #"3", #"4", #"5", #"6", #"7", #"8", #"9"]

  fun parseInt str =
    case (Int.fromString str) of
        SOME i => i
      | NONE => raise Match

  val naturalParser = pmap (parseInt o String.implode) (many1 digitParser)

  datatype sign = Positive | Negative

  val signParser =
    let val posParser = seqR (opt (pchar #"+")) (preturn Positive)
        val negParser = seqR (pchar #"-") (preturn Negative)

    in
      or negParser posParser
    end

  fun applySign (Positive, int) = int
    | applySign (Negative, int) = ~int

  val integerParser = pmap (CST.IntConstant o applySign) (seq signParser naturalParser)

  (* Strings *)
  val stringChar = or (seqR (pchar #"\\") (pchar #"\"")) (noneOf [#"\""])
  val quotedString = pmap String.implode (between (pchar #"\"") (many stringChar) (pchar #"\""))

  (* Symbols *)
  val symbolChar = anyOfString Ident.alphabet
  val symbolNameParser = pmap String.implode (many1 symbolChar)
end