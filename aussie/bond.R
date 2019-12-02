library(tidyverse)
library(rvest)

url1 <- "https://bond.edu.au/current-students/study-information/subjects?type=1&area=All&page="
url2 <- "https://bond.edu.au/current-students/study-information/subjects?type=2&area=All&page="
url3 <- "https://bond.edu.au/current-students/study-information/subjects?type=3&area=All&page="
url4 <- "https://bond.edu.au/current-students/study-information/subjects?type=4&area=All&page="

url1_range <- 0:35
url2_range <- 0:30
url3_range <- 0:0
url4_range <- 0:1

output <- tibble('code'=character(),
                 'title'=character(),
                 'type'=character())

for (i in url1_range) {
  this_url <- paste0(url1, url1_range[i])
  page <- read_html(this_url)
  
  data <- page %>%
    html_nodes("td") %>%
    html_text() %>%
    str_remove(" ")
  data <- data[-which(data=="")]
  code <- data[c(T,F)]
  title <- data[c(F,T)]
  
  output <- output %>%
    bind_rows(tibble(code=code,
                     title=title,
                     type=rep('Undergraduate', length(code))))
  
  message(i)
}

for (i in url2_range) {
  this_url <- paste0(url2, url2_range[i])
  page <- read_html(this_url)
  
  data <- page %>%
    html_nodes("td") %>%
    html_text() %>%
    str_remove(" ")
  data <- data[-which(data=="")]
  code <- data[c(T,F)]
  title <- data[c(F,T)]
  
  output <- output %>%
    bind_rows(tibble(code=code,
                     title=title,
                     type=rep('Postgraduate', length(code))))
  
  message(i)
}

for (i in url3_range) {
  this_url <- paste0(url3, url3_range[i])
  page <- read_html(this_url)
  
  data <- page %>%
    html_nodes("td") %>%
    html_text() %>%
    str_remove(" ")
  data <- data[-which(data=="")]
  code <- data[c(T,F)]
  title <- data[c(F,T)]
  
  output <- output %>%
    bind_rows(tibble(code=code,
                     title=title,
                     type=rep('Honours', length(code))))
  
  message(i)
}

for (i in url4_range) {
  this_url <- paste0(url4, url4_range[i])
  page <- read_html(this_url)
  
  data <- page %>%
    html_nodes("td") %>%
    html_text() %>%
    str_remove(" ")
  data <- data[-which(data=="")]
  code <- data[c(T,F)]
  title <- data[c(F,T)]
  
  output <- output %>%
    bind_rows(tibble(code=code,
                     title=title,
                     type=rep('Postgraduate', length(code))))
  
  message(i)
}

write_delim(output, delim=",", "./bond.csv")
