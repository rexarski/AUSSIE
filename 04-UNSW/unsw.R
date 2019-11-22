if (!require(pacman)) install.packages("pacman")
pacman::p_load("tidyverse", "rvest", "RSelenium")

url <- "http://timetable.unsw.edu.au/2020/subjectSearch.html"

page <- read_html(url)

subjects <- page %>%
  html_nodes("[class='data']") %>%
  html_text()

kens_start <- which(subjects=="ACCT")
cofa_start <- which(subjects=="ADAD")
adfa_start <- which(subjects=="ZBUS")

kens <- subjects[kens_start:(cofa_start-1)]
kens <- kens[-length(kens)][c(T,F,F)]
cofa <- subjects[cofa_start:(adfa_start-1)]
cofa <- cofa[-length(cofa)][c(T,F,F)]
adfa <- subjects[adfa_start:(length(subjects))]
adfa <- adfa[-length(adfa)][c(T,F,F)]

output <- tibble(code = character(),
                 title = character(),
                 credit = integer(),
                 location = character(),
                 area = character())

schools <- list(kens, cofa, adfa)
school_codes <- c("KENS", "COFA", "ADFA")


for (j in 1:3) {
  for (sub in schools[[j]]) {
    sub_url <- paste0("http://timetable.unsw.edu.au/2020/", sub, school_codes[j], ".html")
    # sub_url <- paste0("http://timetable.unsw.edu.au/2020/", "AERO", "KENS", ".html")
    sub_page <- read_html(sub_url)
    
    data <- sub_page %>% html_nodes("[class='data']") %>%
      html_text()
    
    # What if some subjects do not have Postgraduate or Research courses?
    
    separator1 <- which(data=="Research Courses") + 1
    data <- data[separator1:length(data)]
    separator <- which(data=="Back to top")
    
    section_num <- length(separator)
    slist <- list()
    campus <- c()
    subject_area <- c()
    
    for (k in 1:section_num) {
      if (k==1) {
        campus <- c(campus, data[1])
        subject_area <- c(subject_area, data[2])
        s1 <- data[3:(separator[1]-1)]
        slist[[k]] <- s1
      } else {
        campus <- c(campus, data[separator[k-1]+1])
        subject_area <- c(subject_area, data[separator[k-1]+2])
        slist[[k]] <- data[(separator[k-1]+3):(separator[k]-1)]
      }
    }
    
    # campus <- c(campus, data[separator[1]+1])
    # subject_area <- c(subject_area, data[separator[1]+2])
    # s2 <- data[(separator[1]+3):(separator[2]-1)] #Postgraduate
    # 
    # campus <- c(campus, data[separator[2]+1])
    # subject_area <- c(subject_area, data[separator[2]+2])
    # s3 <- data[(separator[2]+3):(separator[3]-1)] #Research
    # rm(data)
    
    subject_page_data <- tibble(code = character(),
                                title = character(),
                                credit = integer(),
                                location = character(),
                                area = character())
    
    for (i in 1:section_num) {
      s <- slist[[i]]
      code <- s[c(T, F, F)]
      title <- s[c(F, T, F)]
      credit <- as.integer(s[c(F, F, T)])
      location <- rep(campus[i], length(s)/3)
      area <- rep(subject_area[i], length(s)/3)
      section_page_data <- bind_cols(code=code, title=title,
                                     credit=credit, location=location, area=area)
      subject_page_data <- subject_page_data %>%
        bind_rows(section_page_data)
    }
    
    message(paste("Done with subject", sub, "in school", school_codes[j]))
    
    output <- output %>%
      bind_rows(subject_page_data)
  }
  message(paste("Done with school", school_codes[j]))
  # Sys.sleep(5)
}


write_delim(output, delim=",", "./04-UNSW/unsw.csv")

rm(list=ls())
gc()
