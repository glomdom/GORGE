structure Compiler :> COMPILER = struct
  datatype compiler = Compiler of Module.menv * Symbol.module_name
  val emptyCompiler = Compiler (Module.defaultMenv, Ident.mkIdentEx "gorge-user")

  type pathname = string
  datatype compilation_unit = FileUnit of pathname
                            | ReplUnit of string

  fun compileForm (Compiler (menv, currModuleName)) form =
    let val currModule = case Module.envGet menv currModuleName of
        SOME m => m
      | _ => raise Fail "no module with this name"
    
    in
      let val resolved = Util.valOf (RCST.resolve menv currModule form)
      
      in
        raise Fail "not implemented yet"
      end
    end
  
  fun compileForms c (head::tail) = compileForms (compileForm c head) tail
    | compileForms c nil = c

  fun unitForms (FileUnit path) = Parser.parseFile path
    | unitForms (ReplUnit string) = [Parser.parseString string]

  fun compileUnit c u =
    compileForms c (unitForms u)
end
