library(devtools)

if(!require(boliga)){
  install_github("krose/boliga")
}

library(boliga)
library(dplyr)
library(ggplot2)

boliger <- boliga_webscrape_sold(min_sale_date = "2017-01-01", 
                                 max_sale_date = "2021-06-30", 
                                 type = "Villa", 
                                 postal_code = 4000)

boliger <- boliga_webscrape_sold(min_sale_date = "2017-04-01", 
                                 max_sale_date = "2017-06-30", 
                                 type = "Fritidshus", 
                                 postal_code = 4500)
glimpse(boliger)