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

# Define UI for application that draws a histogram
shinyUI(
  fluidPage(
  # Application title
  titlePanel("Discover the Australia IP Landscape"),
  
  # Sidebar with a slider input for number of bins 
  sidebarLayout(
    sidebarPanel(
       #sliderInput("year",
       #            "Year",
       #            min=2003, max=2015, value=2003,sep=""),
       sliderInput("yearrange",
                   "Year range",
                   min=2003, max=2015, value=c(2003, 2005),sep=""),
       checkboxInput("separate", "Do not cluster", FALSE)
    ),
    
    # Show a plot of the generated distribution
    mainPanel(
      tabsetPanel(
        tabPanel(title="Distribution of IP", #value="IPMap",
                sliderInput(inputId="yearrange",
                            label="Year range",
                            min=2003, max=2015, 
                            value=c(2003, 2005),
                            sep=""),
                checkboxInput("separate", "Do not cluster", FALSE),
                leafletOutput("IPMap")
        )
    )
  )
  )
) ## close fluid page
) ## close shinyUI
