library(magrittr)
#https://www.bls.gov/oes/#data
oes_xls <- readxl::read_xlsx('../data/oes_research_2019_allsectors.xlsx')

oes <- oes_xls %>%
  dplyr::mutate_at(
    dplyr::vars(dplyr::matches('^a_')),
    function(x){
      x %>%
        stringr::str_replace('#', '208000') %>%
        stringr::str_replace('\\*', '') %>%
        as.numeric
    }
  ) %>%
  dplyr::mutate_at(
    dplyr::vars(dplyr::matches('^h_')),
    function(x){
      x %>%
        stringr::str_replace('#', '100') %>%
        stringr::str_replace('\\*', '') %>%
        as.numeric
    }
  ) %>%
  dplyr::mutate_at(
    dplyr::vars(dplyr::matches('^(tot|emp|pct|mean)_')),
    function(x){
      x %>%
        stringr::str_replace('~', '0') %>%
        stringr::str_replace('\\*\\*|\\*', '') %>%
        as.numeric 
    }
  ) %>%
  dplyr::mutate(
    naics_head = naics %>%
      as.character() %>%
      stringr::str_extract('^\\d\\d'),
    occ_head = `occ code` %>%
      stringr::str_extract('\\d\\d')
  )

readr::write_csv(oes,'../data/oes_clean.csv')

oes_no_na <- oes %>%
  dplyr::filter_at(
    dplyr::vars(dplyr::matches('^(a_|h_|tot_)')),
    function(x){
      !is.na(x)
    }
  )

readr::write_csv(oes_no_na, '../data/oes_clean_nona.csv')

oes_only_main <- oes_no_na %>%
  dplyr::filter(!area_title %in% c('Puerto Rico', 'Virgin Islands', 'Guam')) %>%
  dplyr::select(-annual, -hourly, -naics_head)

readr::write_csv(oes_only_main, '../data/oes_prod.csv')

zip::zip('../data/oes_prod.zip', '../data/oes_prod.csv')

oes <- unzip('../data/oes_prod.zip')
