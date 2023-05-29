signature IDENT = sig
  type ident

  val alphabet: string

  val mkIdent: string -> ident option
  val mkIdentEx: string -> ident
  val identString: ident -> string
end
