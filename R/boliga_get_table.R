# Go to boliga.dk/salg -> Fill out: Hurtigsøgning and copy the
# resulting url into boliga_webscrape_sold


#' This function retuns a list with the search results
#' from a specific url
#'
#' @param url_address The url you wan't to start
boliga_get_table <- function(url_address){

  boliga_page <- httr::GET(url = url_address, 
                           httr::user_agent("https://github.com/krose/mkonline"))
  
  if(httr::status_code(boliga_page) != 200){
    httr::stop_for_status(boliga_page)
  }
  
  boliga_page <- httr::content(x = boliga_page, as = "text")
  
  boliga_table <- bol_extract_table(boliga_page)
  
  boliga_table
}
