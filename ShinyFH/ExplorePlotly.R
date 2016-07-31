source("ExploreSA3.R")   

library("plotly")
library("stringr")
source("../ExploreSA3.R")   


Pat_Time_State_Lines <- ggplot(
  data = latest_AS3_data_clean, 
  aes(x = Year, 
      y=Nr_PatentApplicants, 
      colour = State,
      group = SA3_Name,
      text = SA3_Name) ) +
  geom_line(stat = "identity") 
ggplotly(Pat_Time_State_Lines, tooltip=c("y", "text"))


                                               

ggplot(latest_AS3_data_BusiDEmPerf, aes(x=Nr_Busi, y=Education, text=SA3_Name, size=Nr_PatentApplicants) ) + 
  facet_grid(Education ~ Type) + 
  geom_point() -> big_plot_BusiDEmPerfDem                              
                                           
                                   
            
              
                                 
                                                       
          
 
  