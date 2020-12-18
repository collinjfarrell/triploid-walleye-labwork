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

mu <- mean(standards$corrected_gross_heat)- 26.453 

var <- (sd(standards$corrected_gross_heat))^2

### Bayesian Regression ###
library(rstanarm)
library(lme4)

ed <- read_csv("gonad_data_for_paper.csv") %>%
  mutate(gsi = gonww/ww)


glm_post1 <- stan_lmer(ED_ww~sex*percent_DM+(1|fishid),
                       data=ed,
                       prior = normal(mu,var))
summary(glm_post1)
pp_check(glm_post1)

glm_fit <- lmer(ED_ww~percent_DM*sex+(1|fishid), data=ed)
summary(glm_fit)

ggplot(ed,aes(x = percent_DM, y = ED_ww, color = sex))+
  geom_point()


