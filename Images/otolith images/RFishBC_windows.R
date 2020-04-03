library(RFishBC)
library(tidyverse)

#####  Settings #####

### Set Working Directory Manually

### digitizeRadii() options

edge_setting <- FALSE 
#If fish was caught prior to May 1, set to TRUE
#If fish was caught on or after May 1, set to FALSE


reader_initials <- "NGA" #Use your initials
read_num <- "1" #change if you read individual more than one

size_window <- 12 #controls window size
color_id <- "grey70" #controls color of ID text
devicetype <- "default" # "X11" for MacOS, "windows" for Windows
 #X11.options(xpos = 1860) # Controls the x-position of the new window for macOS (CJF_Crestmore = 1860)
windows.options(xpos = 0) # Controls x-position for new window for Windows10 (CJF_Wagar = 1051)
scale_bar <- TRUE     # TRUE = scale bar present
scale_bar_length <- 1 #length of scale bar (should be 1mm)
scale_bar_unit <- "mm" #units of scale bar 

color_selected_points <- "magenta" #changes color of points


### Do not change the code below

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
              col.sel = color_selected_points,
              deviceType = devicetype,
              addNote = FALSE
              )
