

#' Function to create the base url for webscraping boliga.
#' 
#' @param min_sale_year as.numeric(). The minimum sale date.
#' @param max_sale_year as.numeric(). The maximum sale date.
#' @param type type "Alle", "Villa", "Rækkehus", "Ejerleglighed", "Fritidshus", "Landejendom" 
#' @param post_no Post number.
#' 
#' @examples 
#' 
#' library(boliga)
#' 
#' boliga_create_base_url(min_sale_year = Sys.Date() - 100,
#'                        max_sale_year = Sys.Date(),
#'                        type = "Fritidshus",
#'                        postal_code = 4500)
#'                        
boliga_create_base_url <- function(min_sale_year = NULL,
                                   max_sale_year = as.numeric(format(Sys.Date(), "%Y")),
                                   type = c("Alle", "Villa", "Rækkehus", "Ejerlejlighed", "Fritidshus", "Landejendom"),
                                   postal_code = NULL){
  
  
  base_url <- "http://www.boliga.dk/salg/resultater?so=1"
  
  sort_by <- "&sort=omregnings_dato-d"
  
  if(!is.null(sort_by)){
    
    base_url <- paste0(base_url, sort_by)
  }

  if(!is.null(min_sale_year) | class(min_sale_year)[1] == "numeric"){
    min_sale_year <- paste0("&salesDateMin=", min_sale_year)
    
    base_url <- paste0(base_url, min_sale_year)
  } else {
    stop("min_sale_year cannot be null and needs to be of class numeric.")
  }
  
  if(!is.null(max_sale_year) | class(max_sale_year)[1] == "numeric"){
    max_sale_year <- paste0("&salesDateMax=", max_sale_year)
    
    base_url <- paste0(base_url, max_sale_year)
  } else {
    stop("max_sale_year cannot be null and needs to be of class numeric.")
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
