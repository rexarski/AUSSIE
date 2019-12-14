library(tidyverse)
library(rvest)

url <- "https://www.timetable.usyd.edu.au/uostimetables/2020/"

output <- tibble(code=character(),
                 title=character(),
                 uni=character(),
                 state=character())

page <- read_html(url)

data <- page %>%
  html_table()

data <- data[[1]]

data <- data %>%
  select(`Unit Code`, `Unit Name`) %>%
  distinct(`Unit Code`, `Unit Name`) %>%
  rename('code'=`Unit Code`,
         'title'=`Unit Name`)

output <- tibble(
  code=data$code,
  title=data$title,
  uni=rep("University of Sydney", nrow(data)),
  state=rep("NSW", nrow(data))
)

write_delim(output, delim=",", "./data-cleaning/usyd2.csv")

rm(list=ls())
gc()
