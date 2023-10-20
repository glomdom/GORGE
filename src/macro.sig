signature MACRO = sig
  datatype match = Match of match_exp list * match_rest
    and match_exp = MatchVariable of Symbol.symbol
                  | MatchKeyword of Symbol.symbol_name
                  | MatchList of match_exp list * match_rest
    and match_rest = MatchRest
                   | MatchFixed

  datatype template_exp = TemplateExp of RCST.rcst
  datatype template_case = TemplateCase of match * template_exp
  datatype template = Template of Symbol.symbol * string option * template_case list
end
