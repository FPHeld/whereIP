library(leaflet)
#library(data.table)
ipgod <- read.csv('IPGOLD27072016/IPGOD.IPGOD102_PAT_APPLICANT.csv')
ipgod <- ipgod[which(!is.na(ipgod$lat)),]
ipgodapp <- read.csv('IPGOLD27072016/IPGOD.IPGOD101_PAT_SUMMARY.csv')

ipgod <- merge(ipgod, ipgodapp, by='australian_appl_no')
rm(ipgodapp);gc()
# 160242

ipgod <- ipgod[which(!is.na(ipgod$application_year)),]
ipgod_cl <- ipgod[,c(1,15,16,21)]
save(ipgod_cl, file='Robjects/ipgodcl')

library(dplyr)
ipgod_cl %>% group_by(application_year) %>% tally()
ipgod_2003 <- ipgod_cl %>% filter(application_year==2003)

ipdist <- dist(ipgod_2003[,c('lon', 'lat')])
ipclust <- kmeans(ipgod_2003[,c('lon', 'lat')], 100)
clus_size <- data.frame(ipclust$centers, size=table(ipclust$cluster))
clus_size <- clus_size[,c(1,2,4)]
colnames(clus_size)[3] <- 'size'

write.csv(clus_size, file='ipgod_2003_k100.csv')

m <- leaflet(data=clus_size) %>% 
      setView(lng = 145.209511, lat = -33, zoom = 3) %>% 
      addCircles(~lon, ~lat, radius=~size*100, #layerId=~zipcode,
                 stroke=FALSE, fillOpacity=0.4, fillColor='blue') %>% 
      addTiles()
m

m <- leaflet(data=ipgod_2003[,c('lat', 'lon')]) %>% 
      addTiles() %>% 
      setView(lng = 145.209511, lat = -33, zoom = 3) %>% 
      addMarkers(clusterOptions = markerClusterOptions()) #%>% 
m

