####################################
# Data Professor                   #
# http://youtube.com/dataprofessor #
# http://github.com/dataprofessor  #
####################################

# Modified from Winston Chang, 
# https://shiny.rstudio.com/gallery/shiny-theme-selector.html

# Concepts about Reactive programming used by Shiny, 
# https://shiny.rstudio.com/articles/reactivity-overview.html

# Load R packages
library(shiny)
library(shinythemes)
library(tigris)     # counties, places (cities), school_districts
library(dplyr)
library(sf)     
library(tmap)
library(leaflet)

options(tigris_use_cache = TRUE, tigris_class = "sf")  #from nameThatPlaceStart file

# ---------------------------------------------------------------------------------------------

# read a map of United States from the U.S. Census Bureau with the "state" function of the tigris package
#  and create an object called us_states
us_states  <- states(cb = TRUE)  

# map an outline map based on this object using the "tmap" package
tm_shape(us_states) + tm_polygons()


not_continential_US <- c("Hawaii",
                         "Alaska",
                         "Commonwealth of the Northern Mariana Islands",
                         "Guam",
                         "United States Virgin Islands",
                         "American Samoa",
                         "Puerto Rico" )

us_states <-  filter(us_states, ! NAME %in% not_continential_US) 


# Define UI
ui <- fluidPage( theme = shinytheme("simplex"), 
                navbarPage(
                     theme = "cerulean", 
                    "GuessThatPlace",
                    
                    tabPanel("Instructions", #could make different panels for different levels
                             mainPanel(
                                 h1("How to Play:"),
                                 
                                 h4("Learn All the Cool Features of GuessThatPlace!")
                             ), # mainPanel 
                            ),
                    
                    tabPanel("Play!", 
                        h1("How Much Geography Do You Know?"),
                        
                        sidebarPanel(selectInput("states", 
                                                 label = "What is the name of the highlighted state?", 
                                                 us_states$NAME)),
                        mainPanel(       leafletOutput(outputId = "map"),
                      ),
                    ),
                    
                    tabPanel("About", mainPanel(
                        h1("Let's tell you a few things"),
                        
                        h4("by Tanya Bearson and Michael Samuels")
                        ),
                    )
                ) # navbarPage
) # fluidPage


# Define server function  
server <- function(input, output) {
  
   output$map <- renderLeaflet({ tm_shape(us_states) +  tm_polygons() 
     })  # I keep getting an error that says "cannot read property id of null"
     
  # })
   
} # server


# Create Shiny object
shinyApp(ui = ui, server = server)