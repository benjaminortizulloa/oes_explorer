getStateSector <- function(dta = oes, state, industry = 'sector', occupation = '00-0000'){
  stateData = dta %>%
    filterOES(state, industry = industry, occupation = occupation) %>%
    dplyr::arrange(
      -tot_emp
    ) %>%
    dplyr::mutate(hasChildren = purrr::map_dbl(naics, countChildrenIndustries, dta = dta, state = state, industry = 2)) 
  
  return(list(type="state", data=stateData))
}
