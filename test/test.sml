structure GorgeTest = struct
  open MLUnit

  val tests = suite "SUnit Tests" [
    isTrue' true,
    isFalse' false
  ]

  fun runTests () = runAndQuit tests defaultReporter
end

val _ = GorgeTest.runTests()
