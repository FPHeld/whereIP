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
                    checkboxInput("separate", "Do not cluster", FALSE)),
           
           tabPanel("States Trends",
                    plotlyOutput("trendStates")
                    ),
           tabPanel("Demographics")
)
)

