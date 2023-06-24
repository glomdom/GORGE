structure GorgeTest = struct
  open MLUnit

  (* Test Utilities *)
  structure ps = Parsimony(ParsimonyStringInput)

  fun strInput str =
    ParsimonyStringInput.fromString str

  fun isParse input output =
    is (fn () => let val v = Parser.parseString input
      in
        if v = output then
          Pass
        else
          Fail "parse successful, but not equal to output"
      end

      handle _ => Fail "bad parse")

    input

  fun isNotParse input =
    is (fn () => let val v = Parser.parseString input
      in
        Fail "parse successful, should have failed"
      end

      handle _ => Pass)

    input

  fun isFailure value msg =
    is (fn () => case value of
        (Util.Result v) => Fail "value is an instance of Util.Result"
      | Util.Failure _ => Pass)

    msg

  val i = Ident.mkIdentEx

  fun unsym s = CST.UnqualifiedSymbol (i s)
  fun qsym m s = CST.QualifiedSymbol (Symbol.mkSymbol (i m, i s))
  fun escape s = CST.escapedToString (CST.escapeString s)

  (* Test Suites *)
  local
    open CST
  in
    val parserSuite = suite "Parser" [
      suite "Integers" [
        isParse "123" (IntConstant "123"),
        isParse "0" (IntConstant "0"),
        isParse "00" (IntConstant "00"),
        isParse "10000" (IntConstant "10000"),
        isParse "10000" (IntConstant "10000"),
        isParse "-10000" (IntConstant "-10000")
      ],

      suite "Floats" [
        isParse "0.0" (FloatConstant "0.0"),
        isParse "-0.0" (FloatConstant "-0.0"),
        isParse "123.0" (FloatConstant "123.0"),
        isParse "-123.0" (FloatConstant "-123.0"),
        isParse "123.456" (FloatConstant "123.456"),
        isParse "-123.456" (FloatConstant "-123.456"),
        isParse "123.456e3" (FloatConstant "123.456e3"),
        isParse "-123.456e3" (FloatConstant "-123.456e3")
      ],

      suite "Strings" [
        isParse "\"test\"" (StringConstant (escapeString "test")),
        isParse "\"test \\\"herp\\\" test\"" (StringConstant (escapeString "test \"herp\" test")),
        isEqual' (escape "line\\nline") "line\nline",
        isEqual' (escape "line\\rline") "line\rline",
        isEqual' (escape "line\\tline") "line\tline",
        isEqual' (escape "line\\\\line") "line\\line",
        isEqual' (escape "line\\ \\line") "lineline",
        isEqual' (escape "line\\  \\line") "lineline",
        isEqual' (escape "line\\   \\line") "lineline",
        isEqual' (escape "line\\    \\line") "lineline",
        isEqual' (escape "line\\\n\\line") "lineline",
        isEqual' (escape "line\\\n \n\\line") "lineline",
        isEqual' (escape "line\\\n\n\n\\line") "lineline",
        isEqual' (escape "line\\\n\n     \\line") "lineline"
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
        isParse "(m:a n:b o:c)" (List [qsym "m" "a", qsym "n" "b", qsym "o" "c"]),
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
        isParse "(123)" (List [IntConstant "123"]),
        isParse "(\"test\")" (List [StringConstant (escapeString "test")]),

        suite "Whitespace Handling" [
          isParse "   ()" (List nil),
          isParse "()   " (List nil),
          isParse "(   test)" (List [unsym "test"]),
          isParse "(test   )" (List [unsym "test"]),
          isParse "(   test   )" (List [unsym "test"]),
          isParse "( a b c )" (List [unsym "a", unsym "b", unsym "c"])
        ],

        suite "Bad Forms" [
          isNotParse "(",
          isNotParse ")"
        ]
      ]
    ]
  end

  fun rqsym m s = RCST.Symbol (Symbol.mkSymbol (i m, i s))

  local
    open Module
    open Map
  in
    val moduleSuite =
      let val a = Module (i "A", empty, Imports empty, Exports (Set.add Set.empty (i "test")))
          and b = Module (i "B", iadd empty (i "nick", i "A"), Imports (iadd empty (i "test", i "A")), Exports (Set.add Set.empty (i "test")))
          and c = Module (i "C", empty, Imports (iadd empty (i "test", i "B")), Exports Set.empty)

      in
        let val menv = addModule (addModule (addModule emptyEnv a) b) c

        in
          suite "Module System" [
            isEqual (moduleName a) (i "A") "Module Name",
            isEqual (moduleName b) (i "B") "Module Name",
            isEqual (moduleName c) (i "C") "Module Name",

            suite "Symbol Resolution" [
              isEqual (RCST.resolve menv b (CST.IntConstant "+10")) (Util.Result (RCST.IntConstant "+10")) "Int Constant",
              isEqual (RCST.resolve menv b (CST.UnqualifiedSymbol (i "test"))) (Util.Result (rqsym "A" "test")) "Unqualified Symbol - Imported",
              isEqual (RCST.resolve menv b (CST.UnqualifiedSymbol (i "test2"))) (Util.Result (rqsym "B" "test2")) "Unqualified Symbol - Imported",
              isEqual (RCST.resolve menv b (qsym "nick" "test")) (Util.Result (rqsym "A" "test")) "Qualified Symbol - Nickname - Exported",
              isEqual (RCST.resolve menv b (qsym "A" "test")) (Util.Result (rqsym "A" "test")) "Qualified Symbol - Literal - Not Exported",
              isFailure (RCST.resolve menv b (qsym "nick" "test1")) "Qualified Symbol - Nickname - Not Exported",
              isFailure (RCST.resolve menv b (qsym "A" "test1")) "Qualified Symbol - Literal - Not Exported",
              isEqual (RCST.resolve menv c (CST.UnqualifiedSymbol (i "test"))) (Util.Result (rqsym "A" "test")) "Unqualified Symbol - Imported"
            ]
          ]
        end
      end
  end

  val astSuite =
    let val menv = Module.defaultMenv

    in
      let val module = valOf (Module.envGet menv (Ident.mkIdentEx "gorge"))

      in
        let fun parse str = Parser.parseString str
            and resolve cst = Util.valOf (RCST.resolve menv module cst)

        in
          suite "AST" [
            isEqual (resolve (parse "123")) (RCST.IntConstant "123") "IntConstant 123"
          ]
        end
      end
    end

  val tests = suite "Gorge Tests" [
    parserSuite,
    moduleSuite,
    astSuite
  ]

  fun runTests () = runAndQuit tests defaultReporter
end

val _ = GorgeTest.runTests()
