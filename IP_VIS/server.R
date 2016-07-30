#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
load('../Robjects/ipgodcl')

library(dplyr)
# Define server logic required to draw a histogram
#sliderValues <- reactive({
      
#}) 
shinyServer(function(input, output) {
   
  output$IPMap <- renderLeaflet({
        ipgod_2003 <- ipgod_cl %>% filter(application_year %in% c(input$yearrange[1]:input$yearrange[2]))
        if(input$separate){
        leaflet(data=ipgod_2003) %>% 
          setView(lng = 145.209511, lat = -33, zoom = 3) %>% 
          addCircles(~lon, ~lat, radius=1, #layerId=~zipcode,
                     stroke=FALSE, fillOpacity=0.4, fillColor='blue') %>% 
          addTiles()     
        }else{
        leaflet(data=ipgod_2003[,c('lat', 'lon')]) %>% 
              addTiles() %>% 
              setView(lng = 145.209511, lat = -33, zoom = 3) %>% 
              addMarkers(clusterOptions = markerClusterOptions()) #%>% 
        }
  })
  
})
