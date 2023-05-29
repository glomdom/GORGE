structure Type :> TYPE = struct
  datatype param = TypeParam of Symbol.symbol
                 | RegionParam of Symbol.symbol
end
