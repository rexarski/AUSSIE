library(dplyr)
library(stringr)
library(readr)
library(tidyr)
library(rvest)
# library(tibble)

url <- "https://handbooks.uwa.edu.au/search?type=units"
page <- read_html(url)

course_types <- page %>%
  html_nodes("h4") %>%
  html_text()

temp_vec <- unlist(str_split(course_types, " ", n=2))
code = temp_vec[c(T, F)]
title = temp_vec[c(F, T)]

# raw meta
course_meta <- page %>%
  html_nodes("[class='inline tags mobile-hide']") %>%
  html_text()

output <- tibble("code"=code,
                 "title"=title,
                 "meta"=course_meta)

write_delim(output, delim = ",", "uwa.csv")
