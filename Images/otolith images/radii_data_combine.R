library(RFishBC)
library(tidyverse)
library(magrittr)
library(FSA)

fns <- listFiles("rds")

dfrad_wide <- combineData(fns, formatOut = "wide")

dfrad_wide %<>% mutate(rep = str_sub(reading,5,5),
                  fishid = str_sub(id,3,str_length(id)),
                  light_type = str_sub(id,1,1),
                  waterbody = str_sub(fishid,1,3)) %>%
            select(fishid,id, light_type, reading, rep,everything()) %>%
                mutate(light_type = as.factor(light_type),
                       reading = as.factor(reading),
                       waterbody = as.factor(waterbody))

dfrad_long <- combineData(fns)

dfrad_long <- dfrad_wide %>%
  pivot_longer(cols = starts_with("rad"),
               names_to = "ann",
               names_prefix = "rad",
               values_to = "rad",
               values_drop_na = TRUE) %>%
  mutate(waterbody = str_sub(id,3,5))


ggplot(dfrad_wide,aes(agecap,radcap,color = reading))+
  geom_jitter()

ggplot(dfrad_long,aes(as.factor(ann),rad,fill = reading))+
  geom_boxplot() +
  facet_wrap(light_type~waterbody)



age_comp <- dfrad_wide %>%
  select(id,light_type,reading,agecap) %>%
  pivot_wider(id_cols = id,names_from=reading,values_from = agecap)

# Compare All 
age_precision <- agePrecision(~CJF+CJF_1 + JRS_1 + LEL_1,data=age_comp)
summary(age_precision,what="precision")
summary(age_precision,what="detail")


# Self Comparison (CJF - CJF)
age_precision_cjf <- agePrecision(~CJF + CJF_2,data=age_comp)
summary(age_precision_cjf,what = "precision")
summary(age_precision_cjf,what="difference")
summary(age_precision_cjf,what="absolute difference")
summary(age_precision_cjf,what="details")

age_bias_cjf <- ageBias(CJF~CJF_2, data=age_comp)
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
