if (!require(pacman)) install.packages("pacman")
pacman::p_load("tidyverse", "rvest", "RSelenium")

ugurl <- "https://my.uq.edu.au/programs-courses/browse.html?level=ugpg"
pgurl <- "https://my.uq.edu.au/programs-courses/browse.html?level=pgpg"

ug_major <- read_html(ugurl) %>%
  html_nodes("table") %>%
  html_nodes("[class='plan']") %>%
  html_nodes("a") %>%
  html_attr("href")

pg_major <- read_html(pgurl) %>%
  html_nodes("table") %>%
  html_nodes("[class='plan']") %>%
  html_nodes("a") %>%
  html_attr("href")

url_prefix <- "https://my.uq.edu.au"

majors <- unique(union(ug_major, pg_major))

output <- tibble(code = character(),
                 unit = integer(),
                 title = character(),
                 major = character())

# break point
i <- 1

while (i <= length(majors)) {
  
  # Starting from program "Agribusiness" the course list url shifts from:
  # https://my.uq.edu.au/programs-courses/plan_display.html?acad_plan=[program-code]
  # to
  # https://my.uq.edu.au/programs-courses/program_list.html?acad_prog=[program-code]
  # then probably it's better to get the exact url from previous page instead of "putting them together"
  
  major <- majors[i]
  
  message(paste(major, "iteration:", i))
  
  intermediate_page <- paste0(url_prefix, major)
  target_url <- read_html(intermediate_page) %>%
    html_nodes("[class='button green']") %>%
    html_attr("href")
  target_url <- paste0(url_prefix, target_url[1])
  
  if (!str_detect(target_url, "acad_plan")) {
    message("This page has nothing to extract. Jump to next...")
    i <- i + 1
    next
  }
  
  course_list_page <- read_html(target_url)
  major_data <- course_list_page %>%
    html_nodes("[class='trigger']") %>%
    html_text()
  
  # also major_data is different in the second type of webpage:
  
  if (length(major_data)==0) {
    major_data <- NULL
  } else if (length(major_data) > 1) {
    major_data <- paste(major_data, collapse = " & ")
  }
    
  course_data <- course_list_page %>%
    html_nodes("table") %>%
    html_table()
  
  if (length(course_data) == 0) {
    message("This page has nothing to extract. Jump to next...")
    i <- i + 1
    next
  }
  
  new_colnames <- c("code", "unit", "course")
  
  course_list_data <- tibble(v1=character())
  
  course_list_data <- course_list_data %>%
    bind_rows(do.call(rbind.data.frame, course_data)) %>%
    select(code=X1, unit=X2, title=X3) %>%
    filter(code != "Course Code") %>%
    mutate(unit = as.integer(unit),
           title = str_replace_all(title, "[:space:]\\[[:digit:]\\]", ""),
           major = major_data)
  
  output <- output %>%
    bind_rows(course_list_data)
  
  # message(paste("Done with major", major))
  
  # random time out
  if (i %% 20 == 0) {
    timeout <- sample(2, 1)
    message("Time out = ", timeout)
    Sys.sleep(timeout)
  }
  
  # Sys.sleep(0.5)
  i <- i + 1
}

write_delim(output, delim=",", "./data/uq.csv")

# rm(list=ls())
# gc()
