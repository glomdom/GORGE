structure Parser :> PARSER = struct
  structure ps = Parsimony(ParsimonyStringInput)
  open ps

  (* Integers *)
  val digitParser = anyOf [#"0", #"1", #"2", #"3", #"4", #"5", #"6", #"7", #"8", #"9"]
  val naturalParser = pmap String.implode (many1 digitParser)

  datatype sign = Positive | Negative

  val signParser =
    let val posParser = seqR (opt (pchar #"+")) (preturn Positive)
        val negParser = seqR (pchar #"-") (preturn Negative)

    in
      or negParser posParser
    end

  fun applySign (Positive, int) = int
    | applySign (Negative, int) = "-" ^ int

  val integerTextParser = pmap applySign (seq signParser naturalParser)
  val integerParser = pmap CST.IntConstant integerTextParser

  (* Floats *)
  val eParser = or (pchar #"e") (pchar #"E")
  val exponentParser = seqR eParser integerTextParser

  fun toFloat (intPart, (decPart, exponent)) =
    let val expStr = case exponent of
        SOME e => "e" ^ e
      | NONE => ""

    in
      intPart ^ "." ^ decPart ^ expStr
    end

  val floatParser = pmap (CST.FloatConstant o toFloat) (seq integerTextParser (seqR (pchar #".") (seq integerTextParser (opt exponentParser))))

  (* Strings *)
  val stringChar = or (seqR (pchar #"\\") (pchar #"\"")) (noneOf [#"\""])
  val quotedString = pmap (CST.StringConstant o CST.escapeString o String.implode) (between (pchar #"\"") (many stringChar) (pchar #"\""))

  (* Symbols *)
  val symbolChar = anyOfString Ident.alphabet
  val symbolNameParser = pmap (Ident.mkIdentEx o String.implode) (many1 symbolChar)
  val unqualifiedSymbolParser = pmap CST.UnqualifiedSymbol symbolNameParser
  val qualifiedSymbolParser = pmap (CST.QualifiedSymbol o Symbol.mkSymbol) (seq symbolNameParser (seqR (pchar #":") symbolNameParser))
  val keywordParser = pmap CST.Keyword (seqR (pchar #":") symbolNameParser)

  (* Comments *)
  val singleLineComment = seqR (pchar #";") (seqR (many (noneOf [#"\n"])) (pchar #"\n"))

  (* S-Expression *)
  val whitespaceParser = choice [pchar #" ", pchar #"\n", singleLineComment]
  val ws = many whitespaceParser

  fun defineSexpParser listParser = seqR ws (choice [
    floatParser, integerParser, quotedString,
    qualifiedSymbolParser, keywordParser, unqualifiedSymbolParser,
    listParser
  ])

  val listParser =
    let val (sexpParser, r) = wrapper ()

    in
      let val listParser = pmap CST.List (seqR (pchar #"(") (between ws (many (seqL sexpParser ws)) (pchar #")")))

      in
        r := defineSexpParser listParser;
        listParser
      end
    end

  val sexpParser = defineSexpParser listParser

  (* Interface *)
  exception ParserException of string

  fun parseString s =
    case (run sexpParser (ParsimonyStringInput.fromString s)) of
        (Success (r, _)) => r
      | f => raise ParserException ("bad parse: " ^ (explain f))

  fun parseFile path =
    let val code = "(" ^ (Util.readFileToString path) ^ ")"

    in
      case (parseString code) of
          (CST.List l) => l
        | _ => raise ParserException "failed to parse file"
    end
end
