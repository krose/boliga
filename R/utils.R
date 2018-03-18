

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

  pris <- 
    bol_table %>%
    purrr::map(~.x %>% .[2] %>% rvest::html_node("h5") %>% rvest::html_text() %>% stringr::str_replace_all(., "\\.", "")) %>%
    do.call(c, .) %>%
    as.integer()
  
  dato_type_tibble <- 
    bol_table %>%
    purrr::map(~.x %>% .[3] %>% rvest::html_node("h5")) %>%
    purrr::map(~as.character(.x)) %>% 
    purrr::map(~stringr::str_replace_all(.x, "<br>", ",")) %>% 
    do.call(c, .) %>% 
    paste(., collapse = "\n") %>% 
    xml2::read_html() %>% 
    rvest::html_nodes("h5") %>% 
    rvest::html_text() %>% 
    stringr::str_split(., ",", simplify = TRUE) %>% 
    magrittr::set_colnames(c("dato", "salgstype")) %>% 
    tibble::as_tibble() %>% 
    dplyr::mutate(dato = as.Date(dato, format = "%d-%m-%Y"))
  
  pris_kvm <- 
    bol_table %>%
    purrr::map(~.x %>% .[4] %>% rvest::html_node("h5") %>% rvest::html_text() %>% stringr::str_replace_all(., "\\.", "")) %>%
    do.call(c, .) %>% 
    as.integer()
  
  vaerelser <- 
    bol_table %>%
    purrr::map(~.x %>% .[5] %>% rvest::html_node("h5") %>% rvest::html_text()) %>%
    do.call(c, .) %>%
    as.integer()
  
  type <- 
    bol_table %>%
    purrr::map(~.x %>% .[6] %>% rvest::html_node("h5") %>% rvest::html_text()) %>%
    do.call(c, .)

  kvm <- 
    bol_table %>%
    purrr::map(~.x %>% .[7] %>% rvest::html_node("h5") %>% rvest::html_text() %>% stringr::str_replace_all(., "\\.", "")) %>%
    do.call(c, .) %>%
    as.integer()
  
  bygget_aar <- 
    bol_table %>%
    purrr::map(~.x %>% .[8] %>% rvest::html_node("h5") %>% rvest::html_text()) %>%
    do.call(c, .)
  
  udbudsrabat <- 
    bol_table %>%
    purrr::map(~.x %>% .[9] %>% rvest::html_node("h5") %>% rvest::html_text()) %>%
    do.call(c, .) %>%
    stringr::str_replace(., " %", "") %>%
    as.double()
  
  dplyr::bind_cols(tibble::tibble(adresse, pris, pris_kvm, vaerelser, type, kvm, bygget_aar, udbudsrabat), dato_type_tibble)
}
