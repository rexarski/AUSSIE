library(tidyverse)
library(pdftools)

pdf_file <- "https://www.rmit.edu.au/content/dam/rmit/documents/staff-site/servicesandtools/finance/2020-HE-course-list.pdf"

txt <- pdf_text(pdf_file)
# cat(txt[1])
# pdf_data(pdf_file)[[1]]
# pdf_info(pdf_file)

txt2 <- txt %>%
  str_split(pattern = "\r\n") %>%
  unlist()

data <- tibble(
  career=character(),
  campus=character(),
  code=character(),
  eftsl=double(),
  title=character(),
  band_id=character(),
  credit=integer()
)

i <- 1

while (i <= length(txt2)) {
  
  t <- txt2[i] %>%
    str_split("\\s{2,}")

  this_row <- unlist(t)
  
  if (length(this_row)==6) {
    new_col <- unlist(str_split(this_row[4], pattern=" ", n=2))
    this_row <- this_row[-4]
    this_row <- append(this_row, new_col, after=3)
    
    data <- data %>%
      add_row(career=this_row[1],
              campus=this_row[2],
              code=this_row[3],
              eftsl=as.double(this_row[4]),
              title=this_row[5],
              band_id=this_row[6],
              credit=as.integer(this_row[7]))
  } else if (length(this_row)==7) {
    data <- data %>%
      add_row(career=this_row[1],
              campus=this_row[2],
              code=this_row[3],
              eftsl=as.double(this_row[4]),
              title=this_row[5],
              band_id=this_row[6],
              credit=as.integer(this_row[7]))
  }
  
  message(i)
  i <- i + 1
}

data_has_na <- data[rowSums(is.na(data)) > 0,]

output <- anti_join(data, data_has_na)

write_delim(output, delim=",", "./rmit.csv")

# rm(list=ls())
# gc()
