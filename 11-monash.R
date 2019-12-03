library(dplyr)
library(tibble)
library(stringr)
library(readr)
library(tidyr)
library(rvest)

# get first letters of valid unit codes
code_url <- "http://www.monash.edu/pubs/2019handbooks/units/index-bycode.html"

code_page <- read_html(code_url) %>%
  html_nodes("[class='index-code index']") %>%
  html_nodes("a") %>%
  html_text() %>%
  tolower()

output <- tibble("code"=character(),
                 "title"=character())

for (letter in code_page) {
  # letter = 'a'
  unit_url <- paste0("http://www.monash.edu/pubs/2019handbooks/units/index-bycode-",letter,".html")
  
  # hbk-index-list hbk-index-list__units hbk-index-list__units__codes
  titles <- read_html(unit_url) %>%
    html_nodes("[class='hbk-index-list hbk-index-list__units hbk-index-list__units__codes']") %>%
    html_nodes("li") %>%
    html_text()
  
  codes <- read_html(unit_url) %>%
    html_nodes("[class='hbk-index-list hbk-index-list__units hbk-index-list__units__codes']") %>%
    html_nodes("a") %>%
    html_text()
  
  output <- output %>% rbind(tibble("code"=codes, "title"=titles))
  
  message(letter)
  
}

# write.csv(output, file="monash.csv")
write_delim(output, delim = ",", "monash.csv")
