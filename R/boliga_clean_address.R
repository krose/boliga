
#' This is a helper function to take the base adress, which concatenate
#' the house number and postal code, and return a new and improved adress
#' seperating the house number and postal code.
#'
#' @param bad_adress Character vector.
#' @export
boliga_clean_address <- function(bad_address){

  # extract the street address number and postal code
  # The road numbers sometimes have character values
  # so the regex must take this into account.
  road_and_postal <-
    bad_address %>%
    stringr::str_extract(string = .,
                         pattern = "([[:digit:]]{1,4}+[[:alpha:]]{1,2}+[[:digit:]]{4})|[[:digit:]]{1,8}")

  postal_code <-
    road_and_postal %>%
    stringr::str_sub(string = ., start = -4L)

  road_number <-
    road_and_postal %>%
    stringr::str_sub(string = ., end = -5L)

  new_road_and_postal <-
    paste0(road_number, ", ", postal_code)

  good_adress <-
    bad_address %>%
    stringr::str_replace(string = .,
                         pattern = "([[:digit:]]{1,4}+[[:alpha:]]{1,2}+[[:digit:]]{4})|[[:digit:]]{1,8}",
                         replacement = new_road_and_postal)

  return(good_adress)
}
