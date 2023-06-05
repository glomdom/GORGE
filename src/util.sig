signature UTIL = sig
  datatype 'a result = Result of 'a
                     | Failure of string

  val valOf: 'a result -> 'a

  type path = string
  val readFileToString: path -> string

  val member : ''a -> ''a list -> bool
end
