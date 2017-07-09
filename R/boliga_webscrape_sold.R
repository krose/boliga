#' This is the primary function to webscrape boliga
#' for the actual sale prices
#'
#' The function takes the search results from the base url
#' and iterates until there's no "next" page.
#'
#' @param url_address The url you wan't to start
#' @param pause the function with rnorm(1, 1, 0.2) if TRUE, when webscrapping.
#' @export
#' @importFrom magrittr %>%
boliga_webscrape_sold <- function(url_address, random_pause = TRUE){

  # Parse the base url to get hostname and path
  base_url <- httr::parse_url(url_address)
  
  bol_base <- paste0("http://", base_url$hostname,"/", base_url$path)

  # Get table and url
  table_and_url <- boliga_get_table_and_url(url_address = url_address, 
                                            boliga_base_url = bol_base)

  # Get the table from the page
  boliga_table <- table_and_url[[1]]

  # Get the next url
  next_url <- table_and_url[[2]]

  # While the next_url isn't returning NA
  # continue and parse the next page
  while(!is.na(next_url)){

    # build the url of the "next" page
    next_boliga_url <- paste0("http://", base_url$hostname,"/", base_url$path, next_url)

    # Get the next urls table and the next_urls next_url
    temp_table_and_url <- boliga_get_table_and_url(url_address = next_boliga_url, 
                                                   boliga_base_url = bol_base)

    # Row bind the boliga_table and the temp_table
    boliga_table <- rbind(boliga_table, temp_table_and_url[[1]])

    # def next url
    next_url <- temp_table_and_url[[2]]

    # Pause function a bit if TRUE
    if(random_pause){
      Sys.sleep(time = rnorm(n = 1, mean = 1, sd = 0.2))
    }
  }

  # rename variables
  names(boliga_table) <- c("vej", "koebesum", "dato_type", "kvm_pris", "rum", "boligtype", "kvm", "bygget", "udbudsrabat", "aktuel_pris")

  # parse the pris and pris_kvm to numeric
  # parse the Dato to POSIXct
  boliga_table$pris <- stringr::str_replace_all(boliga_table$koebesum, "[[:punct:]]", "") %>% as.numeric()

  # Find fire tal efterfulgt af et mellemrum og behold resten af linjen efter mellemrummet.
  boliga_table$post_by <- stringr::str_extract(string = boliga_table$vej, pattern = '((([0-9]{4})+[" "])+(.*))')

  # Fjern post_by fra vej.
  boliga_table$vej <- stringr::str_replace(string = boliga_table$vej, pattern = boliga_table$post_by, replacement = "")
  boliga_table$pris_kvm <- stringr::str_replace_all(boliga_table$kvm_pris, "[[:punct:]]", "") %>% as.numeric()
  boliga_table$dato <- lubridate::dmy(stringr::str_sub(boliga_table$dato_type, start = 1L, end = 10))
  boliga_table$bygget <- as.integer(boliga_table$bygget)
  boliga_table$kvm <- as.integer(boliga_table$kvm)
  boliga_table$type <- stringr::str_replace(boliga_table$dato_type, "[0-9]{2}+[[:punct:]]{1}+[0-9]{2}+[-]{1}+[0-9]{4}", "")
  boliga_table$udbudsrabat <- stringr::str_replace(boliga_table$udbudsrabat, " %", "") %>% as.numeric()
  boliga_table$udbudsrabat <- boliga_table$udbudsrabat / 100

  boliga_table <-
    boliga_table %>%
    dplyr::select(-koebesum, -dato_type, -aktuel_pris, -kvm_pris)

  return(boliga_table)
}
