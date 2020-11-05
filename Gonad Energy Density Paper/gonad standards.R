library(tidyverse)
library(lubridate)

#### Sigma Estimation ####

standards <- read_csv("standards.csv") %>%
  mutate(date = mdy(str_sub(standard,3,8)))

ggplot(standards)+
  geom_histogram(aes(corrected_gross_heat), binwidth = 0.05)+
  geom_vline(aes(xintercept = 26.453))

standards2 <-
  standards %>%
  filter(corrected_gross_heat < 30)

ggplot(standards2)+
  geom_histogram(aes(corrected_gross_heat), binwidth = 0.05)+
  geom_vline(aes(xintercept = 26.453))

# Benzoic Acid Standard 26.454

26.453 - mean(standards$corrected_gross_heat)

sd(standards$corrected_gross_heat)

### Bayesian Regression ###
library(rstanarm)

ed <- read_csv("gonad_data_for_paper.csv")                                                                                                                   


glm_post1 <- stan_glm(ED_ww~percent_DM, data=ed, family=gaussian)
summary(glm_post1)
pp_check(glm_post1)

glm_fit <- lm(ED_ww~percent_DM, data=ed                                                                                        )
summary(glm_fit)
