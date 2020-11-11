library(magrittr)
source('utils.R')
source('states.R')

#* @filter cors
cors <- function(req, res) {
  res$setHeader("Access-Control-Allow-Origin", "*")
  
  plumber::forward()
}

#' Get Industries for a state
#' @get /state
#' @param state state
getStateSector