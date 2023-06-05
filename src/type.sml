structure Type :> TYPE = struct
  datatype param = TypeParam of Symbol.symbol

  datatype gtypespec = Unit
                     | Bool
                     | Integer of signedness * width
                     | Float of float_type
                     | NamedType of Symbol.symbol
                     | TypeCons of Symbol.symbol * (gtypespec list)
       and signedness = Unsigned | Signed
       and width = Int8 | Int16 | Int32 | Int64
       and float_type = Single | Double

  datatype typedef = TypeAlias of param list * gtypespec
                   | DataType of param list * gtypespec

  type tenv = (Symbol.symbol, typedef) Map.map
end
