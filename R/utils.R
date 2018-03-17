

bol_extract_table <- function(bol_html){
  
  bol_table <- 
    bol_html %>%
    rvest::html_nodes("#searchresult") %>%
    rvest::html_nodes("tr") %>% 
    purrr::map(~rvest::html_nodes(.x, "td"))
  
  adresse <- 
    bol_table %>%
    purrr::map(~.x %>% .[1] %>% rvest::html_node("a")) %>%
    purrr::map(~as.character(.x)) %>% 
    purrr::map(~stringr::str_replace_all(.x, "<br>", ", ")) %>%
    do.call(c, .) %>%
    paste(., collapse = "\n") %>%
    xml2::read_html(.) %>% 
    rvest::html_nodes("a") %>%
    rvest::html_text()

  adresse
}
