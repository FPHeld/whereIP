library(shiny)
library(dplyr)
source("../ExploreSA3.R")      
load('../working/IPGOD_data_all.RData') 

shinyServer(function(input, output) {
   
  output$IPMap <- renderLeaflet({
    ipgod_sel <- IPGOD_data_all %>% 
      filter( application_year >= min(input$yearrange), 
              application_year <= max(input$yearrange))
    ipgod_sel$status <- as.factor(ipgod_sel$status)
    ipgod_sel_stat <- ipgod_sel %>% filter(status %in% input$statusinc)
    ipgod_sel_stat <- ipgod_sel_stat %>% filter(field_en %in% input$IPC8_Cat)
    #ipgod_sel_stat <- ipgod_sel_stat %>% filter(field_en =="Biotechnology")
    if(!input$separate){
      factpal <- colorFactor(brewer.pal(length(levels(ipgod_sel$status)),"Paired"), ipgod_sel$status)
      #factpal <- colorFactor(topo.colors(length(levels(ipgod_sel$status))), ipgod_sel$status)
      #ipgod_sel_stat <- ipgod_sel
      leaflet(data=ipgod_sel_stat) %>% 
        setView(lng = 145.209511, lat = -33, zoom = 3) %>% 
        #color = ~ ifelse(Category == 'BRIBERY', 'red', 'blue')
        addTiles() %>% 
        addCircleMarkers(~lon, ~lat, radius=3, #layerId=~zipcode,
                         stroke=FALSE, 
                         fillOpacity=0.4, 
                         #fillColor=~status, 
                         color=~factpal(status)) %>% 
        addLegend(pal = factpal, title="Status", values = ~ipgod_sel$status, opacity = 1)
    }else{
      leaflet(data=ipgod_sel_stat[,c('lat', 'lon')]) %>% 
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
