if (!require(pacman)) install.packages("pacman")
pacman::p_load("tidyverse", "rvest")

url <- "https://handbook.unimelb.edu.au/search?types%5B%5D=subject&year=2020&level_type%5B%5D=all&campus_and_attendance_mode%5B%5D=all&org_unit%5B%5D=all&page=1&sort=_score%7Cdesc"


current_doc <- read_html(url)

page_num <- current_doc %>%
  html_node(".search-results__paginate > span:nth-child(3)") %>%
  html_text() %>%
  str_remove("of ") %>%
  as.integer()

output <- tibble(course_name = character(),
                 course_code = character(),
                 meta = character(),
                 meta_second = character())

i <- 1

while (i <= page_num) {
  if (i != 1) {
    url <- paste0("https://handbook.unimelb.edu.au/search?types%5B%5D=subject&year=2020&level_type%5B%5D=all&campus_and_attendance_mode%5B%5D=all&org_unit%5B%5D=all&page=", i,
                  "&sort=_score%7Cdesc")
    current_doc <- read_html(url)
  }
  
  data <- current_doc %>%
    html_nodes("[class='search-result-item__anchor']")
  
  course_name <- data %>%
    html_nodes("h3") %>%
    html_text()
  
  course_code <- data %>%
    html_nodes("[class='search-result-item__code']") %>%
    html_text()
  
  meta <- data %>%
    html_nodes("[class='search-result-item__meta-primary']") %>%
    html_text()
  
  meta_second <- data %>%
    html_nodes("[class='search-result-item__meta-secondary']") %>%
    html_text()
  
  output <- output %>%
    bind_rows(tibble(course_name=course_name,
                     course_code=course_code,
                     meta=meta,
                     meta_second=meta_second))
  
  if (i %% 50 == 0) {
    message("taking a break every 50 pages")
    Sys.sleep(5)
  }
  message(paste0("Yike! Done with page", i))
  
  i <- i + 1
}

write_delim(output, delim = ",", "./data/umel.csv")

rm(list=ls())
gc()

