library(tidyverse)
library(magrittr)

gonads <- read_csv("Data/Calorimetry/Gonads/nar_gonad_ed.csv") %>%
  left_join(read_csv("Data/Tissue Drying/NAR/Nar March 2019 Gonad Drying.csv")) %>%
  mutate(percent_DM=dry_tissue/wet_tissue,
         ED_ww = percent_DM*corrected_gross_heat)  %>%
  filter(percent_DM != 0)

  

gonads_grouped <- gonads %>%
  group_by(fishid) %>%
  summarize(mean_ED = mean(ED_ww),
            sd_ED = sd(ED_ww),
            percent_DM = mean(percent_DM))

ggplot(gonads, aes(y = ED_ww, x = percent_DM))+
  geom_point()

summary(lm(ED_ww ~ percent_DM, data = gonads))

ggplot(gonads_grouped, aes(y = mean_ED, x = percent_DM*100))+
  geom_point()+
  labs(x = "Dry Matter Content (%)", y = "Mean Energy Density (kJ/g wet mass)")+
  theme_classic()

summary(lm(log(mean_ED)~ log(percent_DM), data = gonads_grouped))

power_summary <- summary(lm(log(mean_ED)~ log(percent_DM), data = gonads_grouped))

sqrt(sum(power_summary$residuals^2)/25)

