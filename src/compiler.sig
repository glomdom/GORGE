signature COMPILER = sig
  type compiler
  val emptyCompiler: compiler

  type pathname = string
  datatype compilation_unit = FileUnit of pathname
                            | ReplUnit of string

  val compileForms: compiler -> CST.cst list -> compiler
  val compileUnit: compiler -> compilation_unit -> compiler
end
