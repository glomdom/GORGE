structure Compiler :> COMPILER = struct
  datatype compiler = Compiler of unit
  val emptyCompiler = Compiler ()

  type pathname = string
  datatype compilation_unit = FileUnit of pathname
                            | ReplUnit of string

  fun compileForms c forms =
    raise Fail "not implemented yet"

  fun compileUnit c (FileUnit path) = raise Fail ""
    | compileUnit c (ReplUnit string) = raise Fail ""
end
