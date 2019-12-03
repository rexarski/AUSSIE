library(tidyverse)
library(rvest)

url <- "https://www.vu.edu.au/courses/search?iam=resident&query=&type=Unit"

page <- read_html(url)

per_page <- page %>%
  html_nodes("[class='results-summary']") %>%
  html_text() %>%
  str_extract_all("[:digit:]+") %>%
  unlist()
total <- as.integer(per_page[3])
per_page <- as.integer(per_page[2])

output <- tibble(code=character(),
                 title=character(),
                 level=character(),
                 campus=character())

i <- 1
page_num <- 0

while (i < (total + 1)) {
  
  if (page_num > 1) {
    url <- paste0("https://www.vu.edu.au/courses/search?iam=resident&type=Unit&page=",
                   page_num,"&query=")
    page <- read_html(url)
  }
  
  title <- page %>%
    html_nodes("h3") %>%
    html_text() %>%
    str_trim()
  
  title <- title[2:((per_page)+1)]
  title_meta <- title %>%
    str_split(" - ")
  title2 <- c()
  for (l in title_meta) {
    if (length(l) > 1) {
      title2 <- c(title2, l[2])
    } else if (length(l)==1) {
      title2 <- c(title2, l)
    }
  }
  
  meta <- page %>%
    html_nodes("[class='course-meta']") %>%
    html_text() %>%
    str_trim()
  
  level <- c()
  campus <- c()
  code <- c()
  
  j <- 1
  need <- rep(c("Code", "Level", "Campus"), per_page)
  
  # should use length(meta) instead of 30, but there is one case that the last item in meta which indexes at 30 is missing
  while (j <= (3*length(title2))) {
    
    if (length(meta)==29 && startsWith(meta[29], "Level")) {
      meta <- c(meta, "Campus: NA")
    }
    
    if (startsWith(meta[j], need[j])) {
      if (j %% 3 == 1) {
        code <- c(code, meta[j])
      } else if (j %% 3 == 2) {
        level <- c(level, meta[j])
      } else {
        campus <- c(campus, meta[j])
      }
    } else {
      if (j %% 3 == 1) {
        code <- c(code, NA)
      } else if (j %% 3 == 2) {
        level <- c(level, NA)
      } else {
        campus <- c(campus, NA)
      }
      meta <- append(meta, paste0(need[j], ": ", NA), after=j-1)
    }
    j <- j + 1
  }
  
  level <- meta[c(F,T,F)] %>%
    str_replace("Level:", "") %>%
    str_trim()
  campus <- meta[c(F,F,T)] %>%
    str_replace("Campus:", "") %>%
    str_trim()
  campus <-  gsub(" +", " ", campus)
  code <- meta[c(T,F,F)] %>%
    str_replace("Code:", "") %>%
    str_trim()
  
  page_data <- tibble('code'=code,
                      'title'=title2,
                      'level'=level,
                      'campus'=campus)
  output <- bind_rows(output, page_data)
  
  message(page_num)
  i <- i + per_page
  page_num <- page_num + 1
}

write_delim(output, delim=",", "./victoria.csv")

# rm(list=ls())
# gc()
