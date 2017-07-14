

#' Function to create the base url for webscraping boliga.
#' 
#' @param min_sale_date as.Date(). The minimum sale date.
#' @param max_sale_date as.Date(). The maximum sale date.
#' @param type type fritidshus, ... ... .. 
#' @param post_no Post number.
#' 
#' @examples 
#' 
#' library(boliga)
#' 
#' boliga_create_base_url(min_sale_date = Sys.Date() - 100,
#'                        max_sale_date = Sys.Date(),
#'                        type = "Fritidshus",
#'                        post_no = 4500)
#'                        
boliga_create_base_url <- function(min_sale_date = NULL,
                                   max_sale_date = Sys.Date(),
                                   type = NULL,
                                   post_no = NULL){
  
  
  base_url <- "http://www.boliga.dk/salg/resultater?so=1"
  
  sort_by <- "&sort=omregnings_dato-d"
  
  if(!is.null(sort_by)){
    
    base_url <- paste0(base_url, sort_by)
  }
  
  if(!is.null(min_sale_date)){
    min_sale_date <- paste0("&minsaledate=", min_sale_date)
    
    base_url <- paste0(base_url, min_sale_date)
  } else {
    stop("min_sale_date cannot be null.")
  }
  
  if(!is.null(max_sale_date)){
    max_sale_date <- paste0("&maxsaledate=", max_sale_date)
    
    base_url <- paste0(base_url, max_sale_date)
  } else {
    stop("max_sale_date cannot be null.")
  }
  
  if(!is.null(type)){
    type <- paste0("&type=", type)
    
    base_url <- paste0(base_url, type)
  } else {
    stop("type cannot be null.")
  }
  
  if(!is.null(post_no)){
    post_no <- paste0("&iPostnr=", post_no)
    
    base_url <- paste0(base_url, post_no)
  } else {
    stop("post_no cannot be null.")
  }
  
  base_url
}