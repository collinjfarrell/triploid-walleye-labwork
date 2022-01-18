
#==================================#
########### Libraries ###########
#==================================#

library(RFishBC)
library(tidyverse)
library(magrittr)
library(FSA)

#==================================#
############# Data #################
#==================================#

dfrad_wide <- read_csv("rawdata/ageing/AIM_wide.csv", guess_max = 12000)

#-----------------------------------------#
## Below Code should be moved into new file

ggplot(dfrad_wide,aes(agecap,radcap,color = reading))+
  geom_jitter()

age_comp <- dfrad_wide %>%
  select(fishid,light_type,reading,agecap) %>%
  pivot_wider(id_cols = fishid,names_from=reading,values_from = agecap) %>%
  unnest_wider(JRS_1)%>%
  rename(JRS_1 = ...1,
         JRS_2 = ...2,
         JRS_3 = ...3) %>%
  unnest_wider(NGA_1) %>%
rename(NGA_1 = ...1,
       NGA_3 = ...2) %>%
  unnest_wider(NGA_2) %>%
    rename(NGA_2 = ...1,
           NGA_4 = ...2) %>%
  unnest_wider(LEL_1)%>%
  rename(LEL_1 = ...1,
         LEL_2 = ...2,
         LEL_3 = ...3) %>%
  select(-LEL_3) %>%
  unnest_wider(LSR_1)%>%
  rename(LSR_1 = ...1,
         LSR_2 = ...2) %>%
  unnest_wider(MJS_1)%>%
  rename(MJS_1 = ...1,
         MJS_2 = ...2,
         MJS_3 = ...3) %>%
  unnest_wider(CJF_1) %>%
  rename(CJF_1 = ...1,
         CJF_4 = ...2) %>%
  select(-...3) %>%
  unnest_wider(CJF_2) %>%
  rename(CJF_2 = ...1,
         CJF_5 = ...2) %>%
  unnest_wider(CJF_3) %>%
  rename(CJF_3 = ...1,
         CJF_6 = ...2)%>%
  unnest_wider(CJF_1qqqqqqqqqqqqqq)%>%
  rename(CJF_7 = ...1) %>%
  unnest_wider(CJF) %>%
  rename(CJF_8 = ...1) %>%
  unnest_wider(EMP_1) %>%
  rename(EMP_1 = ...1)

age_99 <- 
  age_comp %>%
  pivot_longer(!fishid, names_to = "reading", values_to = "age") %>%
  mutate(reader = str_sub(reading,1,3)) %>%
  filter(!is.na(age)) %>%
  mutate(waterbody = str_sub(fishid,1,3)) 

age_comp3 <- age_99 %>%
  filter(waterbody == "M09" | waterbody == "M10" |waterbody == "M11") %>%
  mutate(fishid = paste0("JU",fishid),
         waterbody = str_sub(fishid,1,3)) 

age_comp2 <- 
  age_99 %>%
  filter(waterbody != "M09",
         waterbody != "M10",
         waterbody != "M11") %>%
  bind_rows(age_comp3) %>%
  pivot_wider(id_cols = fishid,names_from = reader, values_from = age,names_repair = "unique") %>%
  unnest_wider(CJF)%>%
  select(-c(...5,...6)) %>%
  rename(CJF_1 = ...1,
         CJF_2 = ...2,
         CJF_3 = ...3,
         CJF_4 = ...4)%>%
  unnest_wider(JRS) %>%
  rename(JRS_1 = ...1,
         JRS_2 = ...2,
         JRS_3 = ...3) %>%
  unnest_wider(NGA) %>%
  rename(NGA_1 = ...1,
         NGA_2 = ...2,
         NGA_3 = ...3,
         NGA_4 = ...4) %>%
  unnest_wider(LEL) %>%
  rename(LEL_1 = ...1,
         LEL_2 = ...2) %>%
  unnest_wider(LSR) %>%
  rename(LSR_1 = ...1,
         LSR_2 = ...2) %>%
  unnest_wider(MJS) %>%
  rename(MJS_1 = ...1,
         MJS_2 = ...2,
         MJS_3 = ...3) %>%
  unnest_wider(EMP) %>%
  rename(EMP_1 = ...1)

age_comp2 <- age_comp %>%
  mutate(waterbody = str_sub(fishid,1,3)) 

age_comp3 <- age_comp2 %>%
  filter(waterbody == "M09" | waterbody == "M10" |waterbody == "M11") %>%
  select(c(fishid, JRS_1,NGA_1,NGA_2)) %>%
  mutate(fishid = paste0("JU",fishid)) %>%
  rename(JRS_4 = JRS_1,
         NGA_5 = NGA_1,
         NGA_6 = NGA_2)
  
age_comp4 <- 
  left_join(age_comp2,age_comp3) %>%
  filter(waterbody != "M09",
         waterbody != "M10",
         waterbody != "M11")

age_comp2 %>%
  group_by(waterbody) %>%
  summarize(n = n())

age_precision_cjf <- agePrecision(~CJF_1 + NGA_1,data=age_comp)

summary(age_precision_cjf,what = "precision")
summary(age_precision_cjf,what="difference")
summary(age_precision_cjf,what="absolute difference")
summary(age_precision_cjf,what="details")


age_bias_cjf <- ageBias(CJF_1~CJF_4, data=age_comp2)

plot(age_bias_cjf)
plotAB(age_bias_cjf,what="numbers")

# CJF to JRS (Jesse Stokes)
age_precision_jrs <- agePrecision(~CJF_1 + JRS_1, data = age_comp)
summary(age_precision_jrs,what="precision")


age_bias_jrs <- ageBias(JRS_1 ~ CJF_1, data=age_comp)
plot(age_bias_jrs)
plotAB(age_bias_jrs,what="numbers")


# CJF to LEL (Lillian Legg)
age_precision_lel <- agePrecision(~CJF_1 + LEL_1, data = age_comp)
summary(age_precision_lel,what="precision")


age_bias_lel <- ageBias(LEL_1 ~ CJF_1, data=age_comp)
plot(age_bias_lel)
plotAB(age_bias_lel,what="numbers")


# CJF to MJS (Matt Swerdfeger)
age_precision_mjs <- agePrecision(~CJF_1 + MJS_1, data = age_comp)
summary(age_precision_mjs,what="precision")
summary(age_precision_mjs, what="symmetry")

age_bias_mjs <- ageBias(MJS_1 ~ CJF_1, data=age_comp)
plot(age_bias_mjs)
plotAB(age_bias_mjs,what="numbers")

# CJF to LSR (Lindsey Roberts)
age_precision_lsr <- agePrecision(~CJF_1 + LSR_1, data = age_comp)
summary(age_precision_lsr,what="precision")
summary(age_precision_lsr, what="symmetry")

age_bias_lsr <- ageBias(LSR_1 ~ CJF_1, data=age_comp)
plot(age_bias_lsr)
plotAB(age_bias_lsr,what="numbers")

