if (!require(pacman)) install.packages("pacman")
pacman::p_load("tidyverse", "rvest", "RSelenium")

url <- "https://programsandcourses.anu.edu.au/catalogue"

# docker run -d -p 4445:4444 selenium/standalone-firefox

remDr <- remoteDriver(
  remoteServerAddr = "localhost",
  port = 4445L,
  browserName = "firefox"
)
remDr$open()
remDr$navigate(url)

webElem <- remDr$findElement(using = "xpath", "/html/body/div[5]/div[2]/div[1]/div/div/button[2]")
webElem$clickElement()
webElem <- remDr$findElement(using = "xpath", "/html/body/div[5]/form/div/div/div/div/div[3]/div[3]/table/tfoot/tr/td/div/div/span/a")
webElem$clickElement()

doc <- remDr$getPageSource()[[1]]
current_doc <- read_html(doc)

data <- current_doc %>%
  html_node(xpath = "/html/body/div[5]/form/div/div/div/div/div[3]/div[3]/table") %>%
  html_table()

write_delim(data, delim=",", "./01-ANU/anu.csv")

remDr$close()
rm(list=ls())
gc()
