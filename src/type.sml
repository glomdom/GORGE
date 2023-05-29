structure Type :> TYPE = struct
  datatype param = TypeParam of Symbol.symbol
                 | RegionParam of Symbol.symbol

  datatype gtypespec = Unit
                     | Bool
                     | Name of Symbol.symbol
                     | TypeCons of Symbol.symbol * (gtypespec list)

  datatype typedef = TypeAlias of param list * gtypespec
                   | DataType of param list * gtypespec

  type tenv = (Symbol.symbol, typedef) Map.map
end
