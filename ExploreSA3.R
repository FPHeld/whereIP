packages <- c("dplyr", "htmlwidgets", "ggplot2", "ggraptR", "readxl", "readr")

for (i in packages){
if (i %in% installed.packages()){
  library(i, character.only=TRUE)
  } else {
    install.packages(i) 
    library(i, character.only=TRUE)
    }
}

RegionData <- read.csv(file.path("rawdata", "2009-15-SA3-Region-Innovation-Data-csv-geo-au.csv"), stringsAsFactors=FALSE)


ggraptR()
