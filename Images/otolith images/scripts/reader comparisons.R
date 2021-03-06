
#==================================#
########### Libraries ###########
#==================================#

library(RFishBC)
library(tidyverse)
library(magrittr)
library(FSA)

#-----------------------------------------#
## Below Code should be moved into new file

ggplot(dfrad_wide,aes(agecap,radcap,color = reading))+
  geom_jitter()

ggplot(dfrad_long,aes(ann,rad,group = ann))+
  geom_boxplot() +
  facet_wrap(light_type~waterbody)

rads <- dfrad_long %>%
  group_by(fishid,ann) %>%
  summarize(rad_mean = mean(rad),
            rad_sd = sd(rad),
            agecap_mean = mean(agecap))%>%
  ungroup()

ggplot(data = rads,aes(ann, rad_mean))+
  geom_pointrange(aes(ymin = (rad_mean-2*rad_sd),
                      ymax = (rad_mean+2*rad_sd)),
                  position = "jitter")

age_comp <- dfrad_wide %>%
  select(fishid,light_type,reading,agecap) %>%
  pivot_wider(id_cols = fishid,names_from=reading,values_from = agecap)


age_precision_cjf <- agePrecision(~CJF_1 + CJF_2 + CJF_3,data=age_comp)

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

