library(shiny)
load('../Robjects/ipgodcl')  # replace this with a call to the API

library(dplyr)
# Define server logic required to draw a histogram
#sliderValues <- reactive({
source("../ExploreSA3.R")      
#}) 
shinyServer(function(input, output) {
   
  output$IPMap <- renderLeaflet({
        ipgod_sel <- ipgod_cl %>% 
                      filter( application_year >= min(input$yearrange), 
                              application_year <= max(input$yearrange))
        if(input$separate){
        leaflet(data=ipgod_sel) %>% 
          setView(lng = 145.209511, lat = -33, zoom = 3) %>% 
          addCircles(~lon, ~lat, radius=1, #layerId=~zipcode,
                     stroke=FALSE, 
                     fillOpacity=0.4, 
                     fillColor='blue') %>% 
          addTiles()     
        }else{
        leaflet(data=ipgod_sel[,c('lat', 'lon')]) %>% 
              addTiles() %>% 
              setView(lng = 145.209511, lat = -33, zoom = 3) %>% 
              addMarkers(clusterOptions = markerClusterOptions()) #%>% 
        }
  })
  
})
