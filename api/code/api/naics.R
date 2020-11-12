getIndustryHierarchy <- function(dta = oes, state, naicsCode, industry = 3, occupation = 'major'){
  industry = as.numeric(industry)
  if(industry <= 2) return("industry must be > 2")
  
  if(stringr::str_detect(naicsCode, '-')){
    naicsCode <- stringr::str_replace(naicsCode, '-', '|^' )
    naicsCode <- paste0('^', naicsCode)
  } else {
    naicsCode <- stringr::str_extract(naicsCode, paste0('^.{', industry -1 ,'}'))
    naicsCode <- paste0('^', naicsCode)
  }
  
  industryGroup <- paste0(industry, '-digit')
  
  naicsData = dta %>%
    filterOES(state, naicsCode, industryGroup, occupation) %>%
    dplyr::mutate(
      a_mean = as.double(a_mean),
      h_mean = as.double(h_mean),
      a_calc_tot = tot_emp * a_mean,
      h_calc_tot = tot_emp * h_mean
    ) %>%
    dplyr::group_by(area_title, naics, naics_title, i_group) %>%
    dplyr::summarise(
      tot_emp = sum(tot_emp),
      a_calc_mean = sum(a_calc_tot)/tot_emp,
      h_calc_mean = sum(h_calc_tot)/tot_emp
    ) %>%
    dplyr::ungroup() %>%
    dplyr::mutate(hasChildren = purrr::map_dbl(naics, countChildrenIndustries, dta = dta, state = state, industry = industry)) %>%
    dplyr::mutate(hasOccupations = purrr::map_dbl(naics, countIndustryOccupation, dta = dta, state = state, industry = industry, occupation = occupation))
  
  return(list(type="naics", data=naicsData))
}

# getIndustryHierarchy(oes, 'Pennsylvania', '237130', industry=3)