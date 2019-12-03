library(tidyverse)
library(rvest)

p1 <- c(0:6, "H")
p2 <- c(8, 9, "H", "T")

urls1 <- paste0("https://solss.uow.edu.au/sid/CAL.USER_SEARCHRESULTS_FORM?p_menu_type=1&p_cal_types=UP&p_breadcrumb_type=1&p_cs=33712196371045825539&p_searchstring=&p_subj_lvl=", p1, "&p_dptname=All+departments&p_session=All+sessions&p_campus=All+campuses&p_method=All+delivery+methods&p_subject=All+subjects&p_year=2020&p_cal_type=U")
urls2 <- paste0("https://solss.uow.edu.au/sid/CAL.USER_SEARCHRESULTS_FORM?p_menu_type=1&p_cal_types=UP&p_breadcrumb_type=1&p_cs=33712196373294165361&p_searchstring=&p_subj_lvl=", p2, "&p_dptname=All+departments&p_session=All+sessions&p_campus=All+campuses&p_method=All+delivery+methods&p_subject=All+subjects&p_year=2020&p_cal_type=P")

output <- tibble(code=character(),
                 title=character(),
                 credit=integer(),
                 type=character())

urls <- c(urls1, urls2)

for (u in urls) {
  page <- read_html(u)
  
  data <- page %>%
    html_nodes("[class='t_b']") %>%
    html_table()
  
  index <- which(urls==u)
  
  data <- data[[1]] %>%
    as_tibble() %>%
    rename(code=`Subject Code`, title=`Subject Name`, credit=`Credit points`) %>%
    mutate(type=c(p1, p2)[index])
  
  output <- output %>%
    bind_rows(data)
  
  message(u)
}

output

write_delim(output, delim=",", "./wollongong.csv")
