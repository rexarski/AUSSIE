library(dplyr)
library(tibble)
library(stringr)
library(readr)
library(tidyr)
library(rvest)
library(RSelenium)

remDr <- remoteDriver(
  remoteServerAddr = "localhost",
  port = 4445L,
  browserName = "firefox"
)
remDr$open()

# get first letters of valid unit codes
code_url <- "https://coursehandbook.mq.edu.au/search?"

page_limit <- 311
i <- 1
output <- tibble("code"=character(),
                 "title"=character())

remDr$navigate(code_url)
Sys.sleep(1)
webElem <- NULL
while(is.null(webElem)){
  webElem <- tryCatch({remDr$findElement(using = 'xpath', 
                                         value = '//*[@id="react-tabs-6"]')},
                      error = function(e){NULL})
  #loop until element with name <value> is found in <webpage url>
}
webElem$clickElement()
Sys.sleep(3)
# remDr$screenshot(display = TRUE)

while (i <= page_limit) {
  page_courses <- read_html(remDr$getPageSource()[[1]]) %>%
    html_nodes("[class='result-item-title']") %>%
    html_text()
  page_output <- str_split_fixed(page_courses, " ", 2)
  colnames(page_output) <- c("code", "title")
  page_output <- as_tibble(page_output)
  output <- output %>%
    rbind(page_output)
  
  # let's go to next page
  nextpageElem <- NULL
  while(is.null(nextpageElem)){
    nextpageElem <- tryCatch({remDr$findElement(using = "css selector",
                                           value = "#pagination-page-next > i:nth-child(1)")},
                        error = function(e){NULL})
    #loop until element with name <value> is found in <webpage url>
  }
  nextpageElem$clickElement()
  Sys.sleep(2)
  # remDr$screenshot(display = TRUE)
  
  message(i)
  i <- i + 1
}

write_delim(output, delim = ",", "200501-mq.csv")

# gc()
# rm(list=ls())
