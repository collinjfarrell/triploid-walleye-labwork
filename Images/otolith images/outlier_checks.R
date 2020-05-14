little <-
  dfrad_wide %>%
  filter(rad1 < mean(dfrad_wide$rad1)-(2*sd(dfrad_wide$rad1))) %>%
  mutate(filetype = ".jpg",
         id = str_c(id,filetype))

big <-
  dfrad_wide %>%
  filter(rad1 > mean(dfrad_wide$rad1)+(2*sd(dfrad_wide$rad1))) %>%
  mutate(filetype = ".jpg",
         id = str_c(id,filetype))

checks <- bind_rows(little,big)

imgs <- checks %>%
  pull(id)
