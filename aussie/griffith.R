library(jsonlite)
library(tibble)

griffith <- fromJSON("griffith.json")

results <- griffith[["response"]][["resultPacket"]][["results"]][["listMetadata"]] %>%
  as_tibble() %>%
  select(academicGrpName, academicGrpDescription, academicCareerName, 
         code, creditPoints, title, campusCode, url) %>%
  unnest(c(academicGrpName, academicGrpDescription, academicCareerName, 
         code, creditPoints, title, campusCode, url))

write_delim(results, delim=",", "./griffith.csv")
