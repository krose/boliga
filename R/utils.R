

bol_extract_table <- function(boliga_content){
  
  browser()
  # parse the text to html
  # find the #searchresult nodes
  # get the table rows and content
  # I used selectorGadget to find the
  # node "#searchresult"
  bol_table <- 
    boliga_content %>%
    xml2::read_html() %>%
    rvest::html_nodes(".mb-3") %>%
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
    purrr::map(~.x %>% .[2] %>% rvest::html_nodes("span") %>% .[2] %>% rvest::html_text() %>% stringr::str_replace_all(., "\\.", "")) %>%
    do.call(c, .) %>%
    as.integer()
  
  salgsdato <- 
    bol_table %>%
    purrr::map(~.x %>% .[3] %>% rvest::html_nodes("span") %>% .[2] %>% rvest::html_text() %>% stringr::str_replace_all(., "\\.", "")) %>%
    do.call(c, .) %>% 
    as.Date(dato, format = "%d-%m-%Y")
  
  boligtype <- 
    bol_table %>%
    purrr::map(~.x %>% .[4] %>% rvest::html_nodes("span") %>% .[4] %>% rvest::html_text() %>% stringr::str_replace_all(., "\\.", "")) %>%
    do.call(c, .)
    
  pris_kvm <- 
    bol_table %>%
    purrr::map(~.x %>% .[5] %>% rvest::html_nodes("span") %>% .[2] %>% rvest::html_text() %>% stringr::str_replace_all(., "\\.", "")) %>%
    do.call(c, .) %>% 
    as.integer()
  
  vaerelser <- 
    bol_table %>%
    purrr::map(~.x %>% .[6] %>% rvest::html_nodes("span") %>% .[2] %>% rvest::html_text()) %>%
    do.call(c, .) %>%
    as.integer()
  
  # type <- 
  #   bol_table %>%
  #   purrr::map(~.x %>% .[6] %>% rvest::html_node("h5") %>% rvest::html_text()) %>%
  #   do.call(c, .)
  # 
  # kvm <- 
  #   bol_table %>%
  #   purrr::map(~.x %>% .[7] %>% rvest::html_node("h5") %>% rvest::html_text() %>% stringr::str_replace_all(., "\\.", "")) %>%
  #   do.call(c, .) %>%
  #   as.integer()
  # 
  # bygget_aar <- 
  #   bol_table %>%
  #   purrr::map(~.x %>% .[8] %>% rvest::html_node("h5") %>% rvest::html_text()) %>%
  #   do.call(c, .)
  # 
  # udbudsrabat <- 
  #   bol_table %>%
  #   purrr::map(~.x %>% .[9] %>% rvest::html_node("h5") %>% rvest::html_text()) %>%
  #   do.call(c, .) %>%
  #   stringr::str_replace(., " %", "") %>%
  #   as.double()
  
  bolig_link <- 
    bol_table %>% 
    purrr::map(~.x %>% .[1] %>% rvest::html_node("a")) %>% 
    purrr::map(., ~rvest::html_attrs(.)) %>% 
    unlist() %>% 
    unname()
  
  res_df <- dplyr::bind_cols(tibble::tibble(adresse, pris, pris_kvm, vaerelser, type, kvm, bygget_aar, udbudsrabat), dato_type_tibble)
  res_df$bolig_link <- bolig_link
  
  res_df
}
