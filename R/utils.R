

bol_extract_table <- function(boliga_content){

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
    purrr::map(~.x %>% .[2] %>% rvest::html_nodes("span") %>% rvest::html_text() %>%
                 stringr::str_replace_all(., "\\.", "") %>% stringr::str_replace_all(., "kr", "") %>%
                 stringr::str_trim()) %>%
    do.call(c, .) %>%
    as.integer()

  salgsdato <-
    bol_table %>%
    purrr::map(~.x %>% .[3] %>% rvest::html_nodes("span") %>% .[1] %>% rvest::html_text() %>% stringr::str_replace_all(., "\\.", "")) %>%
    do.call(c, .) %>%
    as.Date(dato, format = "%d-%m-%Y")

  boligtype <-
    bol_table %>%
    purrr::map(~.x %>% .[3] %>% rvest::html_nodes("span") %>% .[2] %>% rvest::html_text() %>% stringr::str_replace_all(., "\\.", "")) %>%
    do.call(c, .)

  pris_kvm <-
    bol_table %>%
    purrr::map(~.x %>% .[4] %>% rvest::html_nodes("span") %>% .[2] %>% rvest::html_text() %>%
                 stringr::str_replace_all(., "\\.", "") %>% stringr::str_replace_all(., "kr/m²", "") %>%
                 stringr::str_trim()) %>%
    do.call(c, .) %>%
    as.integer()

  vaerelser <-
    bol_table %>%
    purrr::map(~.x %>% .[5] %>% rvest::html_nodes("span") %>% .[1] %>% rvest::html_text() %>% stringr::str_trim()) %>%
    do.call(c, .) %>%
    as.integer()

  m2 <-
    bol_table %>%
    purrr::map(~.x %>% .[4] %>% rvest::html_nodes("span") %>% .[1] %>% rvest::html_text() %>%
                 stringr::str_replace_all(., "\\.", "") %>% stringr::str_replace_all(., "m²", "") %>%
                 stringr::str_trim()) %>%
    do.call(c, .) %>%
    as.integer()

  byggear <-
    bol_table %>%
    purrr::map(~.x %>% .[6] %>% rvest::html_nodes("span") %>% .[1] %>% rvest::html_text()) %>%
    do.call(c, .)  %>%
    as.integer()

  bolig_link <-
    bol_table %>%
    purrr::map(~.x %>% .[1] %>% rvest::html_node("a")) %>%
    purrr::map(., ~rvest::html_attrs(.)) %>%
    unlist() %>%
    unname()

  bolig_link_selected <- bolig_link[seq(4, length(bolig_link), 4)]

  res_df <- dplyr::bind_cols(tibble::tibble(adresse, pris, salgsdato, boligtype, pris_kvm, vaerelser, m2, byggear))
  res_df$bolig_link <- bolig_link_selected

  res_df
}
