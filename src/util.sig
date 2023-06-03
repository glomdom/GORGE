signature UTIL = sig
  datatype 'a result = Result of 'a
                     | Failure of string

  type path = string
  val readFileToString: path -> string

  val member : ''a -> ''a list -> bool
end
