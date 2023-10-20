structure Type :> TYPE = struct
  datatype param = TypeParam of Symbol.symbol

  datatype typespec = Unit
                    | Bool
                    | Integer of signedness * width
                    | Float of float_type
                    | NamedType of Symbol.symbol
                    | TypeCons of Symbol.symbol * (typespec list)
       and signedness = Unsigned | Signed
       and width = Int8 | Int16 | Int32 | Int64
       and float_type = Single | Double

  datatype typedef = TypeAlias of param list * typespec
                   | DataType of param list * typespec

  type tenv = (Symbol.symbol, typedef) Map.map
end
