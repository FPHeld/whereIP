packages <- c("dplyr", "htmlwidgets", "httr")



for (i in packages){
  if (i %in% installed.packages()){
    library(i, character.only=TRUE)
  } else {
    install.packages(i) 
    library(i, character.only=TRUE)
  }
}

latest_AS3_data_loc <- "http://data.gov.au/api/action/datastore_search?resource_id=223e2340-5c0a-4bd8-8818-e3cd2fee13c8&limit=4000"

latest_AS3_data <- jsonlite::fromJSON(latest_AS3_data_loc)$result$records
