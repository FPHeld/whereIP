#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library("shiny")
library("htmlwidgets")
library("leaflet")
library("pairsD3")
library("plotly")
library("RColorBrewer")

#load('../working/IPGOD_data_all.RData') 
#IP_Categories <- sort(unique(IPGOD_data_all$field_en))
load("../working/IP_Categories.RData")
# source("../ExploreSA3.R")   

shinyUI(navbarPage("Discover the Australia IP Landscape",
          tabPanel("Home",
             includeHTML("../WelcomePage.html")
                     ),
          tabPanel("Map",
                   checkboxGroupInput("IPC8_Cat", 
                                      label = "Select IPC Category", 
                                      choices=IP_Categories,
                                      selected=c("Analysis of biological materials",
                                                 "Biotechnology"),
                                      inline = TRUE
                                      ),
                   leafletOutput("IPMap"),
                   fluidRow(#tweaks,
                     column(4,
                            sliderInput(inputId="yearrange",
                                        label="Year range",
                                        min=2003, max=2015, 
                                        value=c(2005, 2010),
                                        sep="")
                            ),
                     column(4,
                            checkboxGroupInput("statusinc", 
                                               label = "Select status",
                                               choices = list("Accepted"="Accepted", 
                                                              "Ceased"="Ceased",
                                                              "Certified"="Certified",
                                                              "Expired"="Expired",
                                                              "Filed"="Filed",
                                                              "Lapsed"="Lapsed",
                                                              "Refused"="Refused",
                                                              "Revoked"="Revoked",
                                                              "Sealed"="Sealed",
                                                              "Withdrawn"="Withdrawn"),
                                               selected = c("Accepted", "Ceased", "Certified",
                                                            "Expired", "Filed", "Lapsed", 
                                                            "Refused", "Revoked", "Sealed",
                                                            "Withdrawn"),
                                               inline=TRUE
                                               #))
                            )),
                     column(2, 
                            checkboxInput("separate", 
                                          label="Cluster", 
                                          value=FALSE)
                            )
                   ) # end fluidRow
          ), #end tabpanel "Map"   
           tabPanel("Trends",
                    plotlyOutput("trendStates", width = "95%", height = "700px"),
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
                    
                    ), #end tabpanel "Trends"
           tabPanel("Capabilities",
                    fluidRow(
                      column(6,
                        selectInput('Dems_Size', 
                                    'Select Performance Measure (Y):',
                                    Trend_Y_choices, 
                                    selected = "Nr_PatentApplicants")
                        ),
                      column(6,             
                        selectInput('Dems_Year', 
                                    'Which Year?:',
                                    sort(unique(latest_AS3_data_BusiDEmPerf$Year)), 
                                    selected = 2011)
                        )
                      ), # end top fluid row

                    plotlyOutput("Demo_Grid", width = "95%", height = "700px"),
                    
                    fluidRow(
                      column(6,
                             checkboxGroupInput('Dems_Busi', 'Show Number of Local Businesses of Types:',
                                                sort(unique(latest_AS3_data_BusiDEmPerf$Type)), 
                                                selected = c("Education","Finance","Health"),
                                                inline = TRUE)      
                      ),
                      column(4,
                             checkboxGroupInput('Dems_Edu', 
                                                label='Show Highest Level Qualification Level in Population:',
                                                choices=sort(unique(latest_AS3_data_BusiDEmPerf$Education)), 
                                                selected = c("Bachelor", "PG"))
                      )
                    ) ## end fluid row
                   ) #end tabpanel "Capabilities"
)
)

