library(tidyverse)
library(rvest)

url <- "http://handbook.murdoch.edu.au/units/?year=2020&sort=UnitCd"

page <- read_html(url)

data <- page %>%
  html_nodes("[class='table table-striped table-light']") %>%
  html_table()

data <- data[[1]]
data <- as_tibble(data)

write_delim(data, delim=",", "./murdoch.csv")
