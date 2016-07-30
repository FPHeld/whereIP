#from http://stackoverflow.com/questions/24174042/matching-georeferenced-data-with-shape-file-in-r

#shapefiles at: http://www.abs.gov.au/AUSSTATS/abs@.nsf/DetailsPage/1270.0.55.001July%202016?OpenDocument

library("rgdal")
ogrDrivers()[24,]
ogrListLayers("SA3_Shapefiles/ESRI Shapefiles/SA3_2016_AUST.shp")
SA3Shapes <- readOGR("SA3_Shapefiles/ESRI Shapefiles/SA3_2016_AUST.shp", layer="SA3_2016_AUST")



plot(SA3Shapes)  # they dont like victoria
SA3Shapes$SA3_NAME16
