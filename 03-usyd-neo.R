# UPDATE WITH "TRIAL SCRAPE": IF DID NOT GET IT, SCRAPE IT AGAIN.
# "Manual try-catch"
# Drawback: if a page has nothing to scrape indeed, then we are gonna have a dead loop; but we will find it out anyway.

library(tidyverse)
library(rvest)
library(RSelenium)

url <- "https://sydney.edu.au/courses/search.html?search-type=uos&page="

output <- tibble(code=character(),
                 title=character(),
                 uni=character(),
                 state=character())

remDr <- remoteDriver(
  remoteServerAddr = "localhost",
  port = 4445L,
  browserName = "firefox"
)
remDr$open()


page_limit <- 682

i <- 1

# webElem <- remDr$findElement(using = "css selector", "#b-course-search-navigation-accordion-3 > h4:nth-child(1) > a:nth-child(1)")
# webElem$clickElement()
# Sys.sleep(5)

while (i <= page_limit) {
  
  url_full <- paste0(url, i)
  remDr$navigate(url_full)
  doc <- remDr$getPageSource()[[1]]
  current_doc <- read_html(doc)
  
  code <- current_doc %>%
    html_nodes("[class='b-result-container__item b-result-container__item--data b-result-container__item--uos-code']") %>%
    html_text()
  
  title <- current_doc %>%
    html_nodes("[class='b-result-container__item b-result-container__item--data b-result-container__item--uos-title']") %>%
    html_text()
  
  output <- output %>%
    bind_rows(tibble(
      'code'=code,
      'title'=title,
      'uni'=rep('University of Sydney', length(code)),
      'state'=rep('NSW', length(code))))
  
  message(paste0("Page: ", i, ", number of units: ", length(code)))
  
  
  if (i %% 25 == 0) {
    message("sleep for 2 seconds...")
    Sys.sleep(2)
  }
  
  if (length(code)==0) {
    message("Retrying...")
    Sys.sleep(3)
  } else {
    i <- i + 1
  }
}

write_delim(output, delim=",", "./data-cleaning/usyd.csv")

remDr$close()
rm(list=ls())
gc()
