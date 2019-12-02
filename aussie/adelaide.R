library(dplyr)
library(tibble)
library(stringr)
library(readr)
library(tidyr)
library(rvest)

url <- "https://www.adelaide.edu.au/course-outlines/"
# somehow this does not require any dynamic javascript coding
course_types <- read_html(url) %>%
  html_nodes("[class='subsections']") %>%
  html_nodes("a") %>%
  html_attr("href")
course_types <- paste0("https://www.adelaide.edu.au", course_types)

output <- tibble("code"=character(),
                 "title"=character(),
                 "campus"=character(),
                 "semester"=character(),
                 "year"=integer())

i <- 1

while (i <= length(course_types)) {
  
  url2 <- course_types[i]
  
  course <- read_html(url2) %>%
    html_nodes("[class='ui-widget-search-results']") %>%
    html_nodes("a") %>%
    html_nodes(xpath="span[2]") %>%
    html_text()
  
  course_meta <- read_html(url2) %>%
    html_nodes("[class='ui-widget-search-results']") %>%
    html_nodes("a") %>%
    html_nodes(xpath="span[3]") %>%
    html_text()
  
  temp_vec <- unlist(str_split(course, " - ", n=2)) # some course titles contain a dash
  code <- temp_vec[c(T, F)]
  title <- temp_vec[c(F, T)]
  
  temp_vec_2 <- unlist(str_split(course_meta, " \\| ", n=3))
  campus <- temp_vec_2[c(T, F, F)]
  semester <- temp_vec_2[c(F, T, F)]
  year <- temp_vec_2[c(F, F, T)] %>%
    as.integer()

  output <- output %>%
    bind_rows(tibble("code"=code, "title"=title, "campus"=campus, 
                     "semester"=semester, "year"=year))
  message(url2, " ", i)
  if (i %% 10 == 0) {
    message("Sleeping...")
    Sys.sleep(5)
  }
  i <- i + 1
}

write_delim(output, delim = ",", "Adelaide.csv")
