signature PARSER = sig
  val parseString: string -> CST.cst
  val parseFile: string -> CST.cst list
end
