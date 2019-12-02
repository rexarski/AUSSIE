library(tidyverse)
library(rvest)
burwood <- "https://www.deakin.edu.au/courses-search/unit-search.php?hidCurrentYear=2020&hidYear=2020&hidType=max&txtUnit=&txtTitle=&txtKeyword=&selLevel=Select&selSemester=Select&selMode=Select&selLocation=B&chkSortby=unit_cd&btnSubmit="
warrnambool <- "https://www.deakin.edu.au/courses-search/unit-search.php?hidCurrentYear=2020&hidYear=2020&hidType=max&txtUnit=&txtTitle=&txtKeyword=&selLevel=Select&selSemester=Select&selMode=Select&selLocation=W&chkSortby=unit_cd&btnSubmit="
waterfront <- "https://www.deakin.edu.au/courses-search/unit-search.php?hidCurrentYear=2020&hidYear=2020&hidType=max&txtUnit=&txtTitle=&txtKeyword=&selLevel=Select&selSemester=Select&selMode=Select&selLocation=S&chkSortby=unit_cd&btnSubmit="
waurnponds <- "https://www.deakin.edu.au/courses-search/unit-search.php?hidCurrentYear=2020&hidYear=2020&hidType=max&txtUnit=&txtTitle=&txtKeyword=&selLevel=Select&selSemester=Select&selMode=Select&selLocation=G&chkSortby=unit_cd&btnSubmit="
urls <- c(burwood, warrnambool, waterfront, waurnponds)
locations <- c("Burwood (Melbourne)", "Warrnambool", "Waterfront (Geelong)", "Waurn Ponds (Geelong)")
output <- tibble(code=character(),
                 title=character(),
                 location=character())
for (i in 1:4) {
  url <- urls[i]
  page <- read_html(url)
  data <- page %>%
    html_nodes("td") %>%
    html_text()
  code <- data[c(T, F)] %>% str_trim()
  title <- data[c(F, T)]
  output <- output %>%
    bind_rows(tibble('code'=code,
                     'title'=title,
                     'location'=locations[i]))
}
write_delim(output, delim=",", "./deakin.csv")
