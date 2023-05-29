signature IDENT = sig
  type ident

  val alphabet: string

  val mkIdent: string -> ident option
  val identString: ident -> string
end
