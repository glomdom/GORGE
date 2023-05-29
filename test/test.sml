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

  fun unsym s = CST.UnqualifiedSymbol (i s)
  fun qsym m s = CST.QualifiedSymbol (Symbol.mkSymbol (i m, i s))

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
        isParse "\"test\"" (StringConstant (escapeString "test")),
        isParse "\"test \\\"herp\\\" test\"" (StringConstant (escapeString "test \"herp\" test"))
      ],
      suite "Symbols" [
        suite "Qualified Symbols" [
          isParse "a:b" (qsym "a" "b"),
          isParse "test:test" (qsym "test" "test")
        ],
        suite "Unqualified Symbols" [
          isParse "test" (unsym "test")
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
        isParse "(test)" (List [unsym "test"]),
        isParse "((a))" (List [List [unsym "a"]]),
        isParse "(a b c)" (List [unsym "a", unsym "b", unsym "c"]),
        isParse "(a b (c d) e f)" (List [
          unsym "a",
          unsym "b",
          List [
            unsym "c",
            unsym "d"
          ],
          unsym "e",
          unsym "f"
        ]),
        isParse "(123)" (List [IntConstant 123]),
        isParse "(\"test\")" (List [StringConstant (escapeString "test")]),

        suite "Whitespace Handling" [
          isParse "   ()" (List nil),
          isParse "()   " (List nil),
          isParse "(   test)" (List [unsym "test"]),
          isParse "(test   )" (List [unsym "test"]),
          isParse "(   test   )" (List [unsym "test"]),
          isParse "( a b c )" (List [unsym "a", unsym "b", unsym "c"])
        ]
      ]
    ]
  end

  val tests = suite "Gorge Tests" [
    parserSuite
  ]

  fun runTests () = runAndQuit tests defaultReporter
end

val _ = GorgeTest.runTests()
