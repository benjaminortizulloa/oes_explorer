getStateSector <- function(dta = oes, state, industry = 'sector', occupation = '00-0000'){
  stateData = dta %>%
    filterOES(state, industry = industry, occupation = occupation) %>%
    dplyr::arrange(
      -tot_emp
    )
  
  return(list(type="state", data=stateData))
}
