library(tidyverse)
library(rvest)

url <- "https://www.newcastle.edu.au/course"

# just like Griffith. need to dig deeper to another page.
# get this url from the response.

url <- "https://www.newcastle.edu.au/course/course-2016-listing"

page <- read_html(url)

data <- page %>%
  html_table()

output <- tibble(code=character(),
                 title=character(),
                 availability=character(),
                 units=character())

message("Total type of courses: ", length(data))

for (i in 1:length(data)) {
  section <- data[[i]]
  colnames(section) <- c("code", "title", "availability", "units")
  section <- as_tibble(section)
  output <- output %>%
    bind_rows(section)
  message(i)
}

write_delim(output, delim=",", "./newcastle.csv")
