# oes <- unzip('../data/oes_prod.zip')
# oes <- read.csv(oes, stringsAsFactors = F, check.names = F)
oes <- read.csv('../data/oes_prod.csv', stringsAsFactors = F, check.names = F)
oes$naics[1400:1700]


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

getStateSector <- function(dta, state, industry = 'sector', occupation = '00-0000'){
  dta %>%
    filterOES(state, industry = industry, occupation = occupation) %>%
    dplyr::arrange(
      -tot_emp
    )
}

getStateSector(oes, 'Pennsylvania')


# children of naic
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

childrenIndustries(oes, '236000', 'Pennsylvania', 3)
countChildrenIndustries(oes, '236000', 'Pennsylvania', 3)

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

industryOccupation(oes, '236000', 'Alaska', 3, 'major')
countIndustryOccupation(oes, '236000', 'Alaska', 3, 'major')

getIndustryHierarchy <- function(dta, state, naicsCode, industry = 3, occupation = 'major'){
  if(industry <= 2) return("industry must be > 2")
  
  if(stringr::str_detect(naicsCode, '-')){
    naicsCode <- stringr::str_replace(naicsCode, '-', '|^' )
    naicsCode <- paste0('^', naicsCode)
  } else {
    naicsCode <- stringr::str_extract(naicsCode, paste0('^.{', industry -1 ,'}'))
    naicsCode <- paste0('^', naicsCode)
  }
  
  industryGroup <- paste0(industry, '-digit')

  dta %>%
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
    dplyr::mutate(hasChildren = purrr::map_dbl(naics, countChildrenIndustry, dta = dta, state = state, industry = industry, occupation = occupation)) %>%
    dplyr::mutate(hasOccupations = purrr::map_dbl(naics, countIndustryOccupation, dta = dta, state = state, industry = industry, occupation = occupation))
}

getIndustryHierarchy(oes, 'Pennsylvania', '237130', industry=3)
