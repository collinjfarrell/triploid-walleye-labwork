library(RFishBC)
library(tidyverse)

#####  Settings #####
### Working Directory
#Change the following settings to set the working directory to the folder the samples you are working on are in

lake <- "PRW" #Three letter code for the lake 
year <- "2019" #Year
light_type <- "Transmitted" #Transmitted or Reflected - Be sure to spell exactly!

### digitizeRadii() options

edge_setting <- FALSE 
#If fish was caught prior to May 1, set to true
#If fish was caught on or after May 1, set to false

reader_initials <- "MJS" #Use your initials
read_num <- "1" #change if you read individual more than one

size_window <- 12 #controls window size
color_id <- "grey70" #controls color of ID text

scale_bar <- TRUE     # TRUE = scale bar present
scale_bar_length <- 1 #length of scale bar (should be 1mm)
scale_bar_unit <- "mm" #units of scale bar 

color_selected_points <- "magenta" #changes color of points


### Do not change the code below

setwd(file.path(lake,year,light_type)) # only run this line once

imgs <- listFiles("jpg")

digitizeRadii(imgs,
              reading=paste0(reader_initials,"_",read_num),
              suffix = paste0(reader_initials,"_",read_num),
              edgeIsAnnulus = edge_setting,
              windowSize = size_window,
              col.info = color_id,
              scaleBar = scale_bar,
              scaleBarLength = scale_bar_length,
              scaleBarUnits = scale_bar_unit,
              col.sel = color_selected_points
              )
