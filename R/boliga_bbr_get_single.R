
#' Function to get the BBR content for a specific relative url.
#' 
#' @param relative_url The relative url.
#' 
#' @export
#' 
#' @examples 
#' 
#' library(boliga)
#' re_url <- "/bbrinfo/3DC48AAF-5E35-43A7-BCB3-3A34565291F6"
#' boliga_bbr_get_single(re_url)
#' 
boliga_bbr_get_single <- function(relative_url){

  url <- paste0("https://www.boliga.dk", relative_url)
  
  get_req <- httr::GET(url)
  
  get_content <- httr::content(get_req, as = "text", encoding = "UTF-8")
  
  get_xml <- xml2::read_html(get_content)
  
  unit_control <- 
    tryCatch(tibble::tibble(bbr_table = "unit", 
                            bbr_var = get_xml %>% rvest::html_nodes("#unitControl .col:nth-child(1) h4") %>% rvest::html_text(., trim = TRUE),
                            bbr_value = get_xml %>% rvest::html_nodes("#unitControl .col:nth-child(2) h4") %>% rvest::html_text(., trim = TRUE),
                            row_nmbr = seq_along(bbr_value)),
             error = function(x){NULL})
  
  ownership_control <- 
    tryCatch(tibble::tibble(bbr_table = "ownership", 
                            bbr_var = get_xml %>% rvest::html_nodes("#ownershipControl .col:nth-child(1) h4") %>% rvest::html_text(., trim = TRUE),
                            bbr_value = get_xml %>% rvest::html_nodes("#ownershipControl .col:nth-child(2) h4") %>% rvest::html_text(., trim = TRUE),
                            row_nmbr = seq_along(bbr_value)),
             error = function(x){NULL})
  
  lots_control <- 
    tryCatch(tibble::tibble(bbr_table = "lots", 
                            bbr_var = get_xml %>% rvest::html_nodes("#lotsControl .col:nth-child(1) h4") %>% rvest::html_text(., trim = TRUE),
                            bbr_value = get_xml %>% rvest::html_nodes("#lotsControl .col:nth-child(2) h4") %>% rvest::html_text(., trim = TRUE),
                            row_nmbr = seq_along(bbr_value)),
             error = function(x){NULL})
  
  evaluation_control <- 
    tryCatch(tibble::tibble(bbr_table = "evaluation", 
                            bbr_var = get_xml %>% rvest::html_nodes("#evaluationControl .col:nth-child(1) h4") %>% rvest::html_text(., trim = TRUE),
                            bbr_value = get_xml %>% rvest::html_nodes("#evaluationControl .col:nth-child(2) h4") %>% rvest::html_text(., trim = TRUE),
                            row_nmbr = seq_along(bbr_value)),
             error = function(x){NULL})
  
  
  building_control <- 
    tryCatch(tibble::tibble(bbr_table = "building", 
                            bbr_var = get_xml %>% rvest::html_nodes("#buildingControl .col:nth-child(1) h4") %>% rvest::html_text(., trim = TRUE),
                            bbr_value = get_xml %>% rvest::html_nodes("#buildingControl .col:nth-child(2) h4") %>% rvest::html_text(., trim = TRUE),
                            row_nmbr = seq_along(bbr_value)),
             error = function(x){NULL})
  
  bbr_df <- dplyr::bind_rows(
    unit_control,
    ownership_control,
    lots_control,
    evaluation_control,
    building_control
  ) %>%
    dplyr::mutate(relative_url = relative_url,
                  downloaded_dt = Sys.time()) %>%
    dplyr::select(relative_url, dplyr::everything())

  bbr_df
}

