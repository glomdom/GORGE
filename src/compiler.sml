structure Compiler :> COMPILER = struct
  datatype compiler = Compiler of Module.menv * Symbol.module_name
  val emptyCompiler = Compiler (Module.defaultMenv, Ident.mkIdentEx "gorge-user")

  type pathname = string
  datatype compilation_unit = FileUnit of pathname
                            | ReplUnit of string

  fun compileForms c forms =
    raise Fail "not implemented yet"

  fun compileUnit c (FileUnit path) = raise Fail ""
    | compileUnit c (ReplUnit string) = raise Fail ""
end
