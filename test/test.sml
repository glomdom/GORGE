structure GorgeTest = struct
  open MLUnit

  (* Test Utilities *)
  structure ps = Parsimony(ParsimonyStringInput)

  fun strInput str =
    ParsimonyStringInput.fromString str

  fun isParse input output =
    is (fn () => case (Parser.parseString input) of
        (Util.Result v) => if v = output then Pass else Fail "parse sucessful, but not equal to output"
      | Util.Failure f => Fail f)

    input

  val i = Ident.mkIdentEx

  (* Test Suites *)
  local
    open CST
  in
    val parserSuite = suite "Parser" [
      suite "Integers" [
        isParse "123" (IntConstant 123),
        isParse "0" (IntConstant 0),
        isParse "00" (IntConstant 0),
        isParse "10000" (IntConstant 10000),
        isParse "+10000" (IntConstant 10000),
        isParse "-10000" (IntConstant ~10000)
      ],
      suite "Strings" [
        isParse "\"derp\"" (StringConstant (escapeString "derp")),
        isParse "\"derp \\\"herp\\\" derp\"" (StringConstant (escapeString "derp \"herp\" derp"))
      ],
      suite "Symbols" [
        suite "Qualified Symbols" [
          isParse "a:b" (QualifiedSymbol (Symbol.mkSymbol (i "a", i "b"))),
          isParse "test:test" (QualifiedSymbol (Symbol.mkSymbol (i "test", i "test")))
        ],
        suite "Unqualified Symbols" [
          isParse "test" (UnqualifiedSymbol (i "test"))
        ],
        suite "Keywords" [
          isParse ":test" (Keyword (i "test"))
        ]
      ],
      suite "S-Expressions" [
        isParse "()" (List nil),
        isParse "(())" (List [List nil]),
        isParse "((()))" (List [List [List nil]]),
        isParse "(((())))" (List [List [List [List nil]]]),
        isParse "(derp)" (List [UnqualifiedSymbol (i "derp")]),
        isParse "((a))" (List [List [UnqualifiedSymbol (i "a")]]),
        isParse "(a b c)" (List [UnqualifiedSymbol (i "a"), UnqualifiedSymbol (i "b"), UnqualifiedSymbol (i "c")]),
        isParse "(a b (c d) e f)" (List [
          UnqualifiedSymbol (i "a"),
          UnqualifiedSymbol (i "b"),
          List [
            UnqualifiedSymbol (i "c"),
            UnqualifiedSymbol (i "d")
          ],
          UnqualifiedSymbol (i "e"),
          UnqualifiedSymbol (i "f")
        ]),
        isParse "(123)" (List [IntConstant 123]),
        isParse "(\"derp\")" (List [StringConstant (escapeString "derp")])
      ]
    ]
  end

  val tests = suite "Gorge Tests" [
    parserSuite
  ]

  fun runTests () = runAndQuit tests defaultReporter
end

val _ = GorgeTest.runTests()
