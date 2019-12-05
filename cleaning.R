rm(list=ls())
gc()

library(tidyverse)
library(jsonlite)

# Adelaide
adelaide <- read_csv("./data-cleaning/adelaide.csv")
adelaide <- adelaide %>%
  filter(year==2019) %>%
  select(code, title) %>%
  distinct(code, title, .keep_all = TRUE) %>%
  mutate(uni="The University of Adelaide",
         state="SA")

# Bond
bond <- read_csv("./data-cleaning/bond.csv")
bond <- bond %>%
  select(code, title) %>%
  distinct(code, title, .keep_all = TRUE) %>%
  mutate(uni="Bond University",
         state="QLD")

# Curtin
curtin <- read_csv("./data-cleaning/curtin.csv")
curtin <- curtin %>%
  select(code, title) %>%
  distinct(code, title, .keep_all = TRUE) %>%
  mutate(uni="Curtin University",
         state="WA")

# Deakin
deakin <- read_csv("./data-cleaning/deakin.csv")
deakin <- deakin %>%
  distinct(code, title, .keep_all = TRUE) %>%
  mutate(uni="Deakin University",
         state="VIC") %>%
  select(code, title, uni, state)

# Griffith
grif <- read_csv("./data-cleaning/griffith.csv")
grif <- grif %>%
  select(code, title) %>%
  distinct(code, title, .keep_all = TRUE) %>%
  mutate(uni="Griffith University",
         state="QLD")

# La Trobe
CapStr <- function(y) {
  export <- c()
  for (yy in y) {
    c <- str_split(yy, " ")[[1]]
    export <- c(export, paste(toupper(substring(c, 1,1)), substring(c, 2),
                              sep="", collapse=" "))
  }
  return(export)
}

latrobe <- read_csv("./data-cleaning/la-trobe.csv", col_names = c("code", "title"))
latrobe <- latrobe %>%
  mutate(code, title=CapStr(str_to_lower(title))) %>%
  distinct(code, title, .keep_all = TRUE) %>%
  mutate(uni="La Trobe University",
         state="VIC")

# Macquarie
macq <- read_csv("./data-cleaning/macquarie.csv", col_names = c("code", "title"))
macq <- macq %>%
  distinct(code, title, .keep_all = TRUE) %>%
  mutate(uni="Macquarie University",
         state="NSW")

# Monash
monash <- read_csv("./data-cleaning/monash.csv")
monash <- monash %>%
  mutate(title=str_trim(str_remove(title, code)),
         uni="Monash University",
         state="VIC") %>%
  distinct(code, title, .keep_all = TRUE)

# Murdoch
murdoch <- read_csv("./data-cleaning/murdoch.csv")
murdoch <- murdoch %>%
  select(Code, Title) %>%
  rename(code="Code", title="Title") %>%
  distinct(code, title, .keep_all = TRUE) %>%
  mutate(uni="Murdoch University",
         state="WA")

# Newcastle
newcastle <- read_csv("./data-cleaning/newcastle.csv")
newcastle <- newcastle %>%
  select(code, title) %>%
  distinct(code, title, .keep_all = TRUE) %>%
  mutate(uni="University of Newcastle",
         state="NSW")

# QUT
qut <- read_csv("./data-cleaning/qut.csv", col_names = c("code", "title")) %>%
  distinct(code, title, .keep_all = TRUE) %>%
  mutate(uni="Queensland University of Technology",
         state="QLD")

# RMIT
rmit <- read_csv("./data-cleaning/rmit.csv") %>%
  select(code, title) %>%
  distinct(code, title, .keep_all = TRUE) %>%
  mutate(uni="RMIT University",
         state="VIC")

# Southern Cross
scu <- read_csv("./data-cleaning/southern-cross.csv") %>%
  select(code, title) %>%
  distinct(code, title, .keep_all = TRUE) %>%
  mutate(uni="Southern Cross University",
         state="NSW")

# UC
uc <- read_csv("./data-cleaning/uc.csv", col_names = c("code", "title"))
uc <- uc %>%
  mutate(title=str_replace(title, " \\(.*\\)", ""),
         uni="University of Canberra",
         state="ACT") %>%
  distinct(code, title, .keep_all = TRUE)

# Tasmania
utas <- read_csv("./data-cleaning/utas.csv", col_names = "title")
utas <- utas %>%
  separate(title, c("title", "code"), sep=" (?=[^ ]+$)",
           extra="merge", fill="right") %>%
  distinct(code, title, .keep_all = TRUE) %>%
  mutate(uni="University of Tasmania",
         state="TAS")

# UTS
uts <- read_csv("./data-cleaning/uts.csv", col_names = "code")
uts <- uts %>%
  separate(code, c("code", "title"),
           extra="merge") %>%
  distinct(code, title, .keep_all = TRUE) %>%
  mutate(uni="University of Technology Sydney",
         state="NSW")

# Western Australia
uwa <- read_csv("./data-cleaning/uwa.csv") %>%
  select(code, title) %>%
  distinct(code, title, .keep_all = TRUE) %>%
  mutate(uni="University of Western Australia",
         state="WA")

# Victoria
vu <- read_csv("./data-cleaning/victoria.csv") %>%
  select(code, title) %>%
  distinct(code, title, .keep_all = TRUE) %>%
  mutate(uni="Victoria University",
         state="VIC")

# Wollongong
wlg <- read_csv("./data-cleaning/wollongong.csv") %>%
  select(code, title) %>%
  distinct(code, title, .keep_all = TRUE) %>%
  mutate(uni="University of Wollongong",
         state="NSW")

# ANU
anu <- read_csv("./data-cleaning/anu.csv") %>%
  select(Code, Title) %>%
  filter(Code!='Show all results...') %>%
  rename(code="Code", title="Title") %>%
  distinct(code, title, .keep_all = TRUE) %>%
  mutate(uni="Australian National University",
         state="ACT")

# Melbourne
melb <- read_csv("./data-cleaning/umel.csv") %>%
  select(course_code, course_name) %>%
  distinct(course_code, course_name, .keep_all = TRUE) %>%
  rename(code="course_code", title="course_name") %>%
  mutate(uni="University of Melbourne",
         state="VIC")

# Sydney
usyd <- read_csv("./data-cleaning/usyd.csv") %>%
  unlist() %>%
  str_split("\\s{2,}") %>%
  unlist()
usyd <- usyd[c(T,F)]
usyd <- as.vector(t(str_match(usyd, '(.*)-(.*)') [,-1])) # this is mesmerizing
usyd <- str_trim(usyd)
code <- usyd[c(F,T)]
title <- usyd[c(T,F)]
usyd <- tibble(code=code, title=title) %>%
  distinct(code, title) %>%
  mutate(uni="University of Sydney",
         state="NSW")

# UNSW
unsw <- read_csv("./data-cleaning/unsw.csv") %>%
  select(code, title) %>%
  distinct(code, title, .keep_all = TRUE) %>%
  mutate(uni="University of New South Wales",
         state="NSW")

# UQ
uq <- read_csv("./data-cleaning/uq.csv")

rm(CapStr)

dfs <- bind_rows(do.call("rbind", lapply(ls(),get)))
# write(toJSON(dfs, pretty = F), "aus-uni.json")

unique(dfs$state)
which(dfs$state=="AGEN3005") #8515
which(dfs$state=="Flavour and Sensory Analysis") #45323
dfs[8510:8520,]
dfs[45320:45325,]
dfs <- dfs[-c(which(dfs$state=="AGEN3005"), 
              which(dfs$state=="Flavour and Sensory Analysis")),]
unique(dfs$state)
unique(dfs$uni)

dfs %>%
  filter(str_detect(title, "\\["))
which(str_detect(dfs$title, "\\["))
dfs <- dfs[-51512,]

dfs %>%
  filter(str_detect(title, "\\]"))

dfs %>%
  filter(str_detect(title, "\b{2}+"))

write_delim(dfs, delim=",", "aus-uni.csv")
