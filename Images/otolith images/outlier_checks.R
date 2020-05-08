little <-
  dfrad_wide %>%
  filter(rad1 < mean(dfrad_wide$rad1)-(2*sd(dfrad_wide$rad1))) %>%
  mutate(filetype = ".jpg",
         id = str_c(id,filetype)) %>%
  pull(id)

big <-
  dfrad_wide %>%
  filter(rad1 > mean(dfrad_wide$rad1)+(2*sd(dfrad_wide$rad1))) %>%
  mutate(filetype = ".jpg",
         id = str_c(id,filetype)) %>%
  pull(id)

imgs <- c(little,big)
