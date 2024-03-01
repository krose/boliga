#' This is the primary function to webscrape boliga
#' for the actual sale prices
#'
#' The function takes the search results from the base url
#' and iterates until there's no "next" page.
#'
#' @param min_sale_year Sale year from as numeric.
#' @param max_sale_year Sale year to as numeric.
#' @param type Type.
#' @param postal_code Postal code.
#' @export
#' @importFrom magrittr %>%
boliga_webscrape_sold <- function(min_sale_year, max_sale_year, type, postal_code){

  base_url <- boliga_create_base_url(min_sale_year = min_sale_year, 
                                        max_sale_year = max_sale_year, 
                                        type = type, 
                                        postal_code = postal_code)
  
  boliga_base <- httr::GET(url = base_url)
  boliga_base_content <- httr::content(boliga_base, as = "text", encoding = "UTF-8")
  
  boliga_base_html <- xml2::read_html(boliga_base_content)
  
  # Get the number of results
  house_count <- 
    boliga_base_html %>% 
    rvest::html_node(".listings-found-text") %>% 
    rvest::html_text() %>%
    stringr::str_replace_all(., "\\.", "") %>%
    readr::parse_number() %>% 
    as.integer()
  
  # There are 50 results per page
  if(is.na(house_count)){
    
    warning(paste0("There are no results from your query.", "This url was create from your request: ", base_url))
    return(NULL)
  }
  page_count <- house_count / 50
  
  if(as.integer(page_count) < page_count){
    page_count <- as.integer(page_count) + 1
  }
  
  # loop over the pages and save the
  # results to the results_list.
  pb <- progress::progress_bar$new(total = page_count)
  result_list <- vector("list", page_count)
  for(page in 1:page_count){
    
    url_address <- glue::glue('{base_url}', '&page={page}')
    #print(url_address)
  
    result_list[[page]] <- boliga_get_table(url_address)
    
    Sys.sleep(time = rgamma(n = 1, shape = 3, scale = 0.3))
    pb$tick()
  }

  boliga_table <- 
    result_list %>%
    dplyr::bind_rows()
  
  boliga_table
}

