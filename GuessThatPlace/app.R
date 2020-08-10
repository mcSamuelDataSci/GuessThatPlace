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


# Define UI
ui <- fluidPage(theme = shinytheme("simplex"), 
                navbarPage(
                     theme = "cerulean", 
                    "GuessThatPlace",
                    tabPanel("Instructions", 
                             mainPanel(
                                 h1("How to Play:"),
                                 
                                 h4("Learn All the Cool Features of GuessThatPlace!")
                             ), # mainPanel
                    ),
                    tabPanel("Play!", mainPanel(
                        h1("Here's the Game..."),
                        
                        h4(":)")
                        )
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
    
   # output$txtout <- renderText({
        #paste( input$txt1, input$txt2, sep = " " )
   # })
} # server


# Create Shiny object
shinyApp(ui = ui, server = server)