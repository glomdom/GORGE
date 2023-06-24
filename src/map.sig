signature MAP = sig
  type (''k, 'v) map

  val empty: (''k, 'v) map
  val get: (''k, 'v) map -> ''k -> 'v option
  val add: (''k, 'v) map -> (''k * 'v) -> (''k, 'v) map option
  val iadd: (''k, 'v) map -> (''k * 'v) -> (''k, 'v) map
  val iaddList: (''k, 'v) map -> (''k * 'v) list -> (''k, 'v) map
  val size: (''k, 'v) map -> int

  val fromList: (''k * 'v) list -> (''k, 'v) map
end
