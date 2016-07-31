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
  
  output$trendStates <- renderPlotly({ 
  Pat_Time_State_Lines <- ggplot(
    data = filter(AS3_data_for_Trends, Remoteness %in% input$Trends_Remoteness) , 
    aes(x = Year,  
        colour = State,
        group = SA3_Name,
        text = SA3_Name) ) +
    geom_line(aes_string(y=input$Trends_Y)) 
  ggplotly(Pat_Time_State_Lines, tooltip=c("y", "text"))
  })

  output$Demo_Grid <- renderPlotly({ 
      big_plot_BusiDEmPerfDem <- ggplot(latest_AS3_data_BusiDEmPerf %>% 
                                          filter( Education %in% input$Dems_Edu, Type %in% input$Dems_Busi ) %>%
                                          filter(Year == input$Dems_Year), 
                                        aes(x=Nr_Busi, 
                                            y=Share_Ed, 
                                            text=SA3_Name,
                                            color=State) ) + 
        facet_grid(Type ~ Education) + 
        geom_point(aes_string(size=input$Dems_Size))    
    ggplotly(big_plot_BusiDEmPerfDem, tooltip=c("x", "y", "size", "text"))
  })
  
})
