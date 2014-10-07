s_arrange = function(.data, ...) {
  eval.string.dplyr(.data,"arrange", ...)
}

s_group_by = function(.data, ...) {
  eval.string.dplyr(.data,"group_by", ...)
}

eval.string.dplyr = function(.data, .fun.name, ...) {
  args = list(...)
  args = unlist(args)
  code = paste0(.fun.name,"(.data,", paste0(args, collapse=","), ")")
  df = eval(parse(text=code,srcfile=NULL))
  df
}
