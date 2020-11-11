usa <- readr::read_csv('https://gist.githubusercontent.com/officeofjane/2c3ed88c4be050d92765de912d71b7c4/raw/8abc5e19a5fac2ec63e81891d9bfdebe2d55f92c/publication-grids.csv')

#not all publications include dc
usa_states <- usa %>%
  dplyr::filter(publication== 'NPR') %>%
  dplyr::mutate(state = stringr::str_replace(state, 'DC', 'District of Columbia')) %>%
  dplyr::select(-id, -publication)

usa_states[which(usa_states$code == 'HI'),]$state = 'Guam'
usa_states[which(usa_states$code == 'HI'),]$code = 'GU'
usa_states[which(usa_states$code == 'FL'),]
usa_states[which(usa_states$code == 'MA'),]
usa_states[which(usa_states$code == 'GU'),]

addStates <- data.frame(
  state = c("Virgin Islands", "Puerto Rico", "Hawaii"),
  code = c('VI', 'PR', 'HI'),
  col = c(13, 13, 2),
  row = c(8, 7, 7)
)

usa_states <- rbind(usa_states, addStates) %>%
  dplyr::arrange(state)

usa_states %>%
  jsonlite::write_json('../data/npr_usa_grid.json')


oes_states <- oes %>%
  dplyr::select(area_title) %>%
  dplyr::distinct()

#confirm that most of OES is in GRID
dplyr::left_join(oes_states, usa_states, c('area_title' = 'state'))

usa_states %>%
  ggplot2::ggplot() +
  ggplot2::geom_rect(ggplot2::aes(xmin = col, xmax = col + 1, ymin = row,ymax = row + 1, fill = runif(length(row))), color = 'white') +
  ggplot2::geom_text(ggplot2::aes(x = col + .5, y = row + .5, label = code), color = 'white') +
  ggplot2::scale_y_reverse() +
  ggplot2::coord_equal()
