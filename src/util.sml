structure Util :> UTIL = struct
  fun member x nil = false
    | member x (y::ys) = (x = y) orelse member x ys
end
