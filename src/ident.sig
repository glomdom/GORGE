signature IDENT = sig
  type ident

  val alphabet: string

  val mk_ident: string -> ident option
  val ident_string: ident -> string
end
