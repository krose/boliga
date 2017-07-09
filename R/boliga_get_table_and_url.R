# Go to boliga.dk/salg -> Fill out: Hurtigsøgning and copy the
# resulting url into boliga_webscrape_sold


#' This function retuns a list with the search results
#' from a specific url
#'
#' @param url_address The url you wan't to start
#' @param boliga_base_url The base url for the loop.
#' @export
boliga_get_table_and_url <- function(url_address, boliga_base_url){

  ## parse the url to get the hostname and path
  boliga_url <- httr::parse_url(url_address)

  # Parse the url_address
  boliga_page <- xml2::read_html(url_address)

  # 1. Take the boliga page
  # 2. find the #searchresult nodes
  # 3. parse the html table
  # 4. get the first list item (our table)
  # I used selectorGadget to find the
  # node "#searchresult"
  boliga_table <-
    boliga_page %>%
    rvest::html_nodes("#searchresult") %>%
    rvest::html_table(dec = ",") %>%
    .[[1]]

  # 1. Take the boliga page
  # 2. find the ".searchresultpaging td~ td+ td a" node
  # 3. get the href attribute
  # I used selectorGadget to find the
  # node ".searchresultpaging td~ td+ td a"
  next_url <-
    boliga_page %>% 
    rvest::html_node("div.pagingWrapper.paddingL") %>% 
    rvest::html_nodes("a") %>% 
    rvest::html_attr("href") %>% 
    tail(n = 1)
  
  if(url_address == paste0(boliga_base_url, next_url)){
    next_url = as.character(NA)
  }

  return(list(boliga_table = boliga_table, next_url = next_url))
}
