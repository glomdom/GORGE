structure Map :> MAP = struct
  datatype (''k, 'v) map = Map of (''k * 'v) list

  val empty = Map []

  fun mapl (Map m) = m

  fun get (Map ((k', v)::rest)) k = if k = k' then SOME v else get (Map rest) k
    | get (Map nil) _ = NONE

  fun add m (k, v) =
    case (get m k) of
        SOME _ => NONE
      | NONE => SOME (Map ((k, v) :: (mapl m)))

  fun iadd m (k, v) =
    case (get m k) of
        SOME _ => m
      | NONE => Map ((k, v) :: (mapl m))

  fun iaddList m (head::tail) = iadd (iaddList m tail) head
    | iaddList m nil = m

  fun size (Map m) = length m

  fun fromList l = iaddList empty l
end
