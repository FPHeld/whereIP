#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
library(htmlwidgets)
library(leaflet)
library("pairsD3")

shinyUI(navbarPage("Discover the Australia IP Landscape",
           tabPanel("Map",
                    leafletOutput("IPMap"),
                    sliderInput(inputId="yearrange",
                                label="Year range",
                                min=2003, max=2015, 
                                value=c(2005, 2010),
                                sep=""),
                    checkboxInput("separate", "Do not cluster", FALSE)), #end tabpanel "Map"
           
           tabPanel("States Trends",
                    plotlyOutput("trendStates"),
                    
                    
                    fluidRow(
                      column(6,
                      checkboxGroupInput('Trends_Remoteness', 'Select Remoteness Categories (filter):',
                                          sort(unique(AS3_data_for_Trends$Remoteness)), 
                                         selected = "Major Cities of Australia")      
                      ),
                      column(6,
                      checkboxGroupInput('Trends_Y', 'Select Performance Measure (Y):',
                                         Trend_Y_choices, 
                                         selected = "Nr_PatentApplicants")
                      )
                    )  # end fluid row of input controls for Trends
                    
                    
                    
                    
                    
                   

                    ), #end tabpanel "State Trends"
           tabPanel("Demographics"
                    ) #end tabpanel "Demographics"
)
)

