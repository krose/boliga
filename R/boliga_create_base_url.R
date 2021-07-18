

#' Function to create the base url for webscraping boliga.
#' 
#' @param min_sale_date as.Date(). The minimum sale date.
#' @param max_sale_date as.Date(). The maximum sale date.
#' @param type type "Alle", "Villa", "Rækkehus", "Ejerleglighed", "Fritidshus", "Landejendom" 
#' @param post_no Post number.
#' 
#' @examples 
#' 
#' library(boliga)
#' 
#' boliga_create_base_url(min_sale_date = Sys.Date() - 100,
#'                        max_sale_date = Sys.Date(),
#'                        type = "Fritidshus",
#'                        postal_code = 4500)
#'                        
boliga_create_base_url <- function(min_sale_date = NULL,
                                   max_sale_date = Sys.Date(),
                                   type = c("Alle", "Villa", "Rækkehus", "Ejerlejlighed", "Fritidshus", "Landejendom"),
                                   postal_code = NULL){
  
  
  base_url <- "http://www.boliga.dk/salg/resultater?so=1"
  
  sort_by <- "&sort=omregnings_dato-d"
  
  if(!is.null(sort_by)){
    
    base_url <- paste0(base_url, sort_by)
  }
  
  if(!is.null(min_sale_date) | class(min_sale_date)[1] == "Date"){
    min_sale_date <- paste0("&minsaledate=", min_sale_date)
    
    base_url <- paste0(base_url, min_sale_date)
  } else {
    stop("min_sale_date cannot be null and needs to be of class Date.")
  }
  
  if(!is.null(max_sale_date) | class(max_sale_date)[1] == "Date"){
    max_sale_date <- paste0("&maxsaledate=", max_sale_date)
    
    base_url <- paste0(base_url, max_sale_date)
  } else {
    stop("max_sale_date cannot be null and needs to be of class Date.")
  }
  
  if(!is.null(type)){
    
    if(length(type) > 1){
      stop("Type can only be of length one.", call. = FALSE)
    }
    test_type <- type %in% c("Alle", "Villa", "Rækkehus", "Ejerlejlighed", "Fritidshus", "Landejendom")
    
    if(!test_type){
      stop("type has to be one of the following: ", 
           paste(c("Alle", "Villa", "Rækkehus", "Ejerlejlighed", "Fritidshus", "Landejendom"), collapse = ", "), 
           call. = FALSE)
    }
    
    if(type == "Alle"){
      type <- ""
    } else{
      type <- paste0("&type=", type)
    }
    
    base_url <- paste0(base_url, type)
  } else {
    stop("type cannot be null.", call. = FALSE)
  }
  
  if(!is.null(postal_code)){
    postal_code <- paste0("&iPostnr=", postal_code)
    
    base_url <- paste0(base_url, postal_code)
  } else {
    stop("post_no cannot be null.")
  }
  
  base_url
}
