signature PARSER = sig
  val parseString: string -> CST.cst Util.result
  val parseFile: string -> CST.cst list Util.result
end
