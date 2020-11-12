library(magrittr)
source('utils.R')
source('states.R')
source("naics.R")

#* @filter cors
cors <- function(req, res) {
  res$setHeader("Access-Control-Allow-Origin", "*")
  
  plumber::forward()
}

#' Get Industries for a state
#' @serializer unboxedJSON
#' @get /state
#' @param state state
getStateSector

#' Get sub industries
#' @serializer unboxedJSON
#' @get /naics
#' @param state state
#' @param naicsCode naics code of industry to drill down
#' @param industry sublevel of industry [3,4,5]
getIndustryHierarchy