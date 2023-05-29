signature UTIL = sig
  datatype 'a result = Result of 'a
                     | Failure of string

  val member : ''a -> ''a list -> bool
end
