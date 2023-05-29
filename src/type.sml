structure Type :> TYPE = struct
  datatype param = TypeParam of Symbol.symbol
                 | RegionParam of Symbol.symbol

  datatype gty = Unit
               | Bool
               | TypeCons of Symbol.symbol * (gty list)
               | Param of Symbol.symbol

  type typedef = param list * gty
  type tenv = (Symbol.symbol, typedef) Map.map
end
