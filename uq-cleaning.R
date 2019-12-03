library(tidyverse)

uq <- tibble(code=character(),
             title=character(),
             uni=character(),
             state=character())

files <- list.files(path="./data")

for (f in files) {
  message(f)
  partial <- read_csv(paste0("data/", f)) %>%
    select(code, title) %>%
    distinct(code, title) %>%
    mutate(uni="University of Queensland",
           state="QLD")
  uq <- bind_rows(uq, partial)
}

uq <- distinct(uq)

write_delim(uq, delim=",", "./data-cleaning/uq.csv")
