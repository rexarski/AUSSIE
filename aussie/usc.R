library(tidyverse)
library(rvest)

subs <- c(paste0(rep("Semester+",2),1:2),
          paste0(rep("Session+",8),1:8),
          paste0(rep("Trimester+",3),1:3))

urls <- paste0("https://www.usc.edu.au/learn/courses-and-programs/courses/search-for-usc-courses?courseCode=&keyword=&teachingPeriodOfOffer=",subs,
               "&school=&offeredLocations=&submit=Search&searchType=coursesonly")

output <- tibble(code=character(),
                 title=character())

for (u in urls) {
  # u <- urls[1]
  
  page <- read_html(u)
  
  status <- page %>%
    html_nodes(xpath="body/div[1]/div[2]/section/div[2]/p") %>%
    html_text() %>%
    str_split(" ") %>%
    unlist()
  
  status <- na.omit(as.integer(status))
  # total <- max(status)
  total <- min(status) # this is PROBLEMATIC
  if (total == Inf) {
    total <- 0
  }
  count <- 0
  page_num <- 1
  while (count < total) {
    message("Page==", page_num)
    scrape_url <- paste0(u,"&p=", page_num)
    
    scrape_page <- read_html(scrape_url)
    
    data <- scrape_page %>%
      html_nodes("[class='search-result-link']") %>%
      html_text() %>%
      str_trim() %>%
      str_split(" ", 2) %>%
      unlist()
    
    code <- data[c(T, F)]
    title <- data[c(F, T)]
    
    output <- output %>%
      bind_rows(tibble('code'=code,
                       'title'=title))
    
    page_num <- page_num + 1
    count <- count + length(code)
  }
  
  message("Done with ", u, ". TeachingPeriod with ", total, " courses on ", (page_num-1), " pages.")
}

output

write_delim(output, delim=",", "./usc-partial.csv")
