#==================================#
########### Libraries ###########
#==================================#

library(RFishBC)
library(tidyverse)
library(magrittr)
library(FSA)


#==================================#
########### Data Import ###########
#==================================#

fns <- list.files(pattern = ".rds", recursive = TRUE) # Reads in all .rds files

#==================================#
########### Wide Format ###########
#==================================#

dfrad_wide <- combineData(fns, formatOut = "wide") # combines data from .rsd file into wide format
                                                  
dfrad_wide2 <- dfrad_wide %>% # creates id variables (ie fishid,waterbody etc) for easier analysis
  mutate(fishid = str_sub(id,3)) %>%
  mutate(fishid = case_when(str_sub(fishid,1,1) == "M" ~ str_c("JU",fishid),
                            str_sub(fishid,1,1) == "X" ~ str_c("AN",fishid),
                            str_sub(fishid,1,1) == "T" ~ str_c("HS",fishid),
                            TRUE ~ as.character(fishid)
  )) %>%
  mutate(
    waterbody = str_sub(fishid,1,3),
    reader = str_sub(reading, start = 1, 3),
    rep = str_sub(reading, 5),
    light_type = str_sub(id, 1, 1)
  ) %>%
  select(fishid,
         waterbody,
         reading,
         reader,
         rep,
         light_type,
         everything())



write_csv(dfrad_wide2,"AIM_wide.csv")

#--------- End Wide  --------------#

#==================================#
########### Long Format ###########
#==================================#

dfrad_long <- combineData(fns) # combines data from .rsd file into long format

dfrad_long2 <- dfrad_long %>% # creates id variables (ie fishid,waterbody etc) for easier analysis
  mutate(fishid = str_sub(id,3)) %>%
  mutate(fishid = case_when(str_sub(fishid,1,1) == "M" ~ str_c("JU",fishid),
                            str_sub(fishid,1,1) == "X" ~ str_c("AN",fishid),
                            str_sub(fishid,1,1) == "T" ~ str_c("HS",fishid),
                            TRUE ~ as.character(fishid)
  )) %>%
  mutate(
    waterbody = str_sub(fishid,1,3),
    reader = str_sub(reading, start = 1, 3),
    rep = str_sub(reading, 5),
    light_type = str_sub(id, 1, 1)
  ) %>%
  select(fishid,
         waterbody,
         reading,
         reader,
         rep,
         light_type,
         everything())

write_csv(dfrad_long2,"AIM_long.csv")
         
#--------- End Long  --------------#



