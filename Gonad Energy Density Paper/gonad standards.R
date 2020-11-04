library(tidyverse)

standards <- read_csv("Data Entry/Calorimetry/Gonads/standards.csv")

ggplot(standards)+
  geom_histogram(aes(corrected_gross_heat), binwidth = 0.05)+
  geom_vline(aes(xintercept = 26.453))

# 26.454

26.453 - mean(standards$corrected_gross_heat)

sd(standards$corrected_gross_heat)

