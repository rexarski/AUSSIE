library(tidyverse)
library(rvest)
library(progress)

url <- "https://www.scu.edu.au/study-at-scu/unit-search/?year=2020"

page <- read_html(url)

last_page_num <- page %>%
  html_nodes("[class='pbc-pag-last']") %>%
  html_text()

last_page_num <- last_page_num[1] %>%
  as.integer()

scrape_targets <- c()

links <- paste0(url, "&page=", 1:last_page_num)

pb <- progress_bar$new(total = last_page_num)

for (l in links) {
  pb$tick()
  
  page <- read_html(l)
  
  table <- page %>%
    html_nodes("tbody") %>%
    html_nodes("tr") %>%
    html_nodes("td") %>%
    html_nodes("a") %>%
    html_attr("href") %>%
    str_remove("//")
  scrape_targets <- c(scrape_targets, table)
  
  Sys.sleep(1 / last_page_num)
}

scrape_targets <- paste0("https://", scrape_targets)

output <- tibble(code=character(),
                 title=character(),
                 meta=character())

pb <- progress_bar$new(format = "  downloading [:bar] :percent eta: :eta",
                       total = length(scrape_targets), clear = FALSE, width= 60)

for (t in scrape_targets) {
  pb$tick()
  
  page <- read_html(t)

  data <- page %>%
    html_nodes("h1") %>%
    html_text() %>%
    str_trim() %>%
    str_split(" - ") %>%
    unlist()
  
  meta <- page %>%
    html_nodes("p") %>%
    html_text()
  meta <- meta[1] %>%
    str_remove("\r\n")
  
  output <- output %>%
    bind_rows(tibble('code'=data[1],
                     'title'=data[2],
                     'meta'=meta))
  pb$tick()
  Sys.sleep(1 / length(scrape_targets))
}

write_delim(output, delim=",", "./southern-cross.csv")
