oes <- read.csv('../../data/oes_prod.csv', stringsAsFactors = F, check.names = F)

filterOES <- function(dta, state = NULL, naicsCode = NULL, industry = NULL, occupation = NULL){
  if(!is.null(state)) {dta <- dplyr::filter(dta, area_title == state)}
  if(!is.null(industry)) {dta <- dplyr::filter(dta, i_group == industry)}
  if(!is.null(occupation)) {
    if(stringr::str_detect(occupation, '^\\d')) {
      dta <- dplyr::filter(dta, `occ code` == occupation)
    } else {
      dta <- dplyr::filter(dta, o_group == occupation)
    }
    
  }
  if(!is.null(naicsCode)) {dta <- dplyr::filter(dta, stringr::str_detect(naics, naicsCode))}
  
  return(dta)
}

childrenIndustries <- function(dta, naic, state, industry, occupation = 'total'){
  nCode <- stringr::str_extract(naic, paste0('^.{', industry, '}'))
  nCode <- paste0('^', nCode)
  iGroup <- paste0(industry + 1, '-digit')
  
  children <- dta %>%
    filterOES(state, nCode, iGroup, occupation)
  
  children
}

countChildrenIndustries <- function(dta, naic, state, industry, occupation = 'total'){
  if(industry >= 6) return(0)
  
  nChildren <- childrenIndustries(dta, naic, state, industry, occupation) %>%
    nrow()
  
  nChildren
}

industryOccupation <- function(dta, naic, state, industry, occupation){
  nCode <- stringr::str_extract(naic, paste0('^.{', industry, '}'))
  iGroup <- paste0(industry, '-digit')
  
  occupations <- dta %>%
    filterOES(state, nCode, iGroup, occupation)
  
  occupations
}

countIndustryOccupation <- function(dta, naic, state, industry, occupation){
  nOccupations <- industryOccupation(dta, naic, state, industry, occupation) %>%
    nrow()
  
  nOccupations
}
