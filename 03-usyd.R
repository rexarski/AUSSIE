if (!require(pacman)) install.packages("pacman")
pacman::p_load("tidyverse", "rvest", "RSelenium")

url <- "https://sydney.edu.au/courses/search.html"

remDr <- remoteDriver(
  remoteServerAddr = "localhost",
  port = 4445L,
  browserName = "firefox"
)
remDr$open()
remDr$navigate(url)

page_limit <- 16214%/%50

i <- 1

output <- c()

webElem <- remDr$findElement(using = "css selector", "#b-course-search-navigation-accordion-3 > h4:nth-child(1) > a:nth-child(1)")
webElem$clickElement()
Sys.sleep(5)

while (i <= page_limit) {
  doc <- remDr$getPageSource()[[1]]
  current_doc <- read_html(doc)
  
  data <- current_doc %>%
    html_nodes("[class='b-tag-list__item-control b-tag-list__item-control--has-child b-position__container b-course-tag b-cta-tile b-cta-tile--compact b-cta-tile--light-grey b-course-tag']") %>%
    html_text() %>%
    str_replace_all("[\r\n]" , "")
  
  output <- c(output, data)
  
  webElem <- remDr$findElement(using = "css selector", "#b-js-course-search-results-uos > div:nth-child(1) > div:nth-child(3) > a:nth-child(7)")
  
  webElem$clickElement()
  Sys.sleep(5)
  
  message(paste0("Page: ", i))
  if (i %% 25 == 0) {
    message("sleep for 5 seconds...")
    Sys.sleep(5)
  }
  i <- i + 1
}

output <- tibble(output)
write_delim(output, delim=",", "./data/usyd.csv")

remDr$close()
rm(list=ls())
gc()
