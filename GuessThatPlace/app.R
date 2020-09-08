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
#tm_shape(us_states) + tm_polygons()






not_continential_US <- c("Hawaii",
                         "Alaska",
                         "Commonwealth of the Northern Mariana Islands",
                         "Guam",
                         "United States Virgin Islands",
                         "American Samoa",
                         "Puerto Rico",
                         "District of Columbia") #DC is too small to see when it's highlighted and isn't a state...

us_states <-  filter(us_states, ! NAME %in% not_continential_US) 


tmap_mode("plot")


random_state    <- us_states %>% sample_n(1) #random
green <- FALSE
#test_state <- filter(us_states, NAME == "California")



gameMap <- function(myState = "Indiana", myShowNames, newState)
{  
  # one_state <- filter(us_states, NAME == myState)
  # other_states <- filter(us_states, ! NAME == myState) #names of all states except highlighte
  
  other_states <- filter(us_states, NAME != random_state$NAME) #names of all states except highlighted
  #other_states <- filter(us_states, NAME != test_state$NAME) #names of all states except highlighted
  
  tempMap <-
    tm_shape(us_states) +
    tm_polygons(col = "slategray2", title = FALSE, popup.vars=c("Acronym:" = "STUSPS", "State:" = "NAME")) +
    tm_shape(random_state, popup.vars = FALSE) +
    tm_fill(col="red2", popup.vars = FALSE) +
    tm_layout(frame = FALSE, bg.color = "grey99") #gets rid of border around map and white background
  
  if (myShowNames){
     tempMap <-
       tm_shape(us_states) +
       tm_polygons(col = "slategray2", title = FALSE, popup.vars=c("Acronym:" = "STUSPS", "State:" = "NAME")) +
       tm_shape(random_state, popup.vars = FALSE) +
       tm_fill(col="red2", popup.vars = FALSE) +
       tm_shape(other_states) +
       tm_text("NAME", size = "AREA",root = 4, fontfamily = "Times") +
       tm_view(text.size.variable = TRUE) +
       tm_layout(frame = FALSE, bg.color = "grey99") #switches state when showing names after pressing generate new state button

  }
  
  if(newState){
    random_state    <<- us_states %>% sample_n(1) #why does it go to red and then switch?
    #test_state <- filter(us_states, NAME == "Kansas")
    
    # tempMap <-
    tm_shape(us_states) +
      tm_polygons(col = "slategray2", title = FALSE, popup.vars=c("Acronym:" = "STUSPS", "State:" = "NAME")) +
      tm_shape(random_state, popup.vars = FALSE) +
      tm_fill(col="red2", popup.vars = FALSE) +
      tm_layout(frame = FALSE, bg.color = "grey99") #gets rid of border around map and white background

  }
  
  
  
  if(myState == random_state$NAME){ #turns state green when correct
    tempMap <-
      tm_shape(us_states) +
      tm_polygons(col = "slategray2", title = FALSE, popup.vars=c("Acronym:" = "STUSPS", "State:" = "NAME")) +
      tm_shape(random_state, popup.vars = FALSE) +
      tm_fill(col="green", popup.vars = FALSE) +
      tm_layout(frame = FALSE, bg.color = "grey99") #doesn't work after pressing generate new state button
    
  }
  
  
  tempMap
  
}

name_states <- sort(us_states$NAME)

# Define UI
ui <- fluidPage( theme = shinytheme("simplex"), 
                 navbarPage(
                   "GuessThatPlace",
                   
                   tabPanel("Play!", 
                            h1("How Much Geography Do You Know?"),
                            
                            sidebarPanel(selectInput(inputId = "states", 
                                                     label = "What is the name of the highlighted state?", 
                                                     choices = name_states)),
                            checkboxInput(inputId = "myShowNames", 
                                         label = "Show Names of States?"),
                            # checkboxInput(inputId = "newState", 
                            #      label = "Generate New State"),
                            actionButton(
                                   inputId = "newState",
                                   label = "Generate New State"
                                 )),
                   mainPanel(plotOutput(outputId = "map"),
                   ),
                   
                   tabPanel("Instructions", #could make different panels for different levels
                            mainPanel(
                              h1("How to Play:"),
                              
                              h4("Learn All the Cool Features of GuessThatPlace!")
                            ), # mainPanel 
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

  output$map <- renderPlot(gameMap(input$states, input$myShowNames, input$newState)) 
  
  } # server


# Create Shiny object
shinyApp(ui = ui, server = server)