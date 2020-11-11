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
