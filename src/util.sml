structure Util :> UTIL = struct
  datatype 'a result = Result of 'a
                     | Failure of string

  fun member x nil = false
    | member x (y::ys) = (x = y) orelse member x ys
end
