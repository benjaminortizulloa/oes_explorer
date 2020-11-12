childrenIndustries <- function(dta, naic, state, industry, occupation = 'total'){
  nCode <- stringr::str_extract(naic, paste0('^.{', industry, '}'))
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