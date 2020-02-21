library(RFishBC)
library(tidyverse)
library(magrittr)

fns <- listFiles("rds")

dfrad_wide <- combineData(fns, formatOut = "wide")

dfrad_wide %<>% mutate(rep = 1,
                  fishid = str_sub(id,3,str_length(id)),
                  light_type = str_sub(id,1,1)) %>%
            select(fishid,id, light_type, reading, rep,everything())

dfrad_long <- combineData(fns)


ggplot(dfrad_wide,aes(agecap,radcap))+
  geom_point()

ggplot(dfrad_long,aes(as.factor(ann),rad))+
  geom_boxplot()
