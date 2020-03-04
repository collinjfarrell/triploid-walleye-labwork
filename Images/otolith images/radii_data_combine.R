library(RFishBC)
library(tidyverse)
library(magrittr)
library(FSA)

fns <- listFiles("rds")

dfrad_wide <- combineData(fns, formatOut = "wide")

dfrad_wide %<>% mutate(rep = 1,
                  fishid = str_sub(id,3,str_length(id)),
                  light_type = str_sub(id,1,1)) %>%
            select(fishid,id, light_type, reading, rep,everything())

dfrad_long <- combineData(fns)


ggplot(dfrad_wide,aes(agecap,radcap,color = reading))+
  geom_jitter()

ggplot(dfrad_long,aes(as.factor(ann),rad,fill = reading))+
  geom_boxplot()



age_comp <- dfrad_wide %>%
  select(fishid,light_type,reading,agecap) %>%
  pivot_wider(id_cols = fishid,names_from=reading,values_from = agecap)

# Compare All 
age_precision <- agePrecision(~CJF_1+CJF_2 + JRS_1 + LEL_1,data=age_comp)
summary(age_precision,what="precision")
summary(age_precision,what="detail")


# Self Comparison (CJF - CJF)
age_precision_cjf <- agePrecision(~CJF_1 + CJF_2,data=age_comp)
summary(age_precision_cjf,what = "precision")
summary(age_precision_cjf,what="difference")
summary(age_precision_cjf,what="absolute difference")
summary(age_precision_cjf,what="details")

age_bias_cjf <- ageBias(CJF_1~CJF_2, data=age_comp)
plot(age_bias_cjf)
plotAB(age_bias_cjf,what="numbers")

# CJF to JRS (Jesse Stokes)
age_precision_jrs <- agePrecision(~CJF_1 + JRS_1, data = age_comp)
summary(age_precision_jrs,what="precision")

# CJF to LEL (Lillian Legg)
age_precision_lel <- agePrecision(~CJF_1 + LEL_1, data = age_comp)
summary(age_precision_lel,what="precision")

# CJF to MJS (Matt Swerdfeger)
age_precision_mjs <- agePrecision(~CJF_1 + MJS_1, data = age_comp)
summary(age_precision_mjs,what="precision")
summary(age_precision_mjs, what="symmetry")
