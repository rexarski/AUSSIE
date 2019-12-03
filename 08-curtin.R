library(tidyverse)
library(rvest)

url <- "http://handbook.curtin.edu.au/unitSearch.html"

# get unit initial letters

page <- read_html(url)

letters <- page %>%
  html_nodes(xpath="/html/body/div[4]/div[2]/p[5]") %>%
  html_nodes("a") %>%
  html_attr("href")

prefix <- "http://handbook.curtin.edu.au/"

urls <- paste0(prefix, letters)

scrape_targets <- c()

for (u in urls) {
  next_page <- read_html(u)
  
  links <- next_page %>%
    html_nodes(xpath="/html/body/div[4]/div[2]/ul") %>%
    html_nodes("a") %>%
    html_attr("href") %>%
    str_replace(pattern="../../", prefix)
  
  scrape_targets <- c(scrape_targets, links)
}

output <- tibble(code=character(),
                 title=character(),
                 area=character(),
                 credit=integer())

# length(scrape_targets) # 3477

i <- 1

while (i <= length(scrape_targets)) {
  each_page <- read_html(scrape_targets[i])
  
  title2 <- each_page %>%
    html_nodes(xpath="//*[@id='breadcrumbs']") %>%
    html_text() %>%
    str_remove_all("\t") %>%
    str_remove_all("\n") %>%
    str_split(">")
  
  title <- title2[[1]][length(title2[[1]])] %>%
    str_trim()
  
  title1 <- each_page %>%
    html_nodes(xpath="/html/body/div[4]/div[2]/h1") %>%
    html_text() %>%
    str_remove_all("\t") %>%
    str_remove_all("\n")
  
  code <- title1 %>%
    str_remove(title) %>%
    str_trim()
  
  meta <- each_page %>%
    html_nodes("td") %>%
    html_text()

  area <- meta[1] %>%
    str_trim()
  
  credit <- meta[2] %>%
    str_trim()
  
  output <- output %>%
    bind_rows(tibble('code'=code,
                     'title'=title,
                     'area'=area,
                     'credit'=as.integer(credit)
                     ))
  message(i)
  i <- i + 1
}

# output[which(is.na(output$credit)),]
# which(is.na(output$credit))

write_delim(output, delim=",", "./curtin.csv")
