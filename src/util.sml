structure Util :> UTIL = struct
  datatype 'a result = Result of 'a
                     | Failure of string

  type path = string
  fun readFileToString filepath =
    let val stream = TextIO.openIn filepath
        fun loop stream =
          case TextIO.inputLine stream of
              SOME line => line :: loop stream
            | NONE => []
    
    in
      String.concat (loop stream before TextIO.closeIn stream)
    end

  fun member x nil = false
    | member x (y::ys) = (x = y) orelse member x ys
end
