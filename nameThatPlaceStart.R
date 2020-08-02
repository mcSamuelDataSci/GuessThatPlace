
# =====================================================================================
# "intial_setup.R" file                                                               |
#                                                                                     |   
# =====================================================================================

library(tigris)     # counties, places (cities), school_districts
library(dplyr)
library(sf)     
library(tmap)

options(tigris_use_cache = TRUE, tigris_class = "sf")  #I was having issues downloading the tigris files and 
#the error recommended adding this "tigris_use_cache = TRUE"
#which worked eventually

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

one_state    <- us_states %>% sample_n(1)

tm_shape(us_states) + tm_polygons(col = "slategray2", popup.vars = FALSE) + tm_shape(one_state) + tm_fill(col="red2", popup.vars = FALSE)

tm_shape(us_states) + tm_polygons(col = "slategray2", title = FALSE, popup.vars=c("Acronym:" = "STUSPS", "State:" = "NAME")) + tm_text("NAME", size = "AREA",root = 4, fontfamily = "Times") +
  tm_view(text.size.variable = TRUE) + tm_shape(one_state, popup.vars = FALSE) + tm_fill(col="red2", popup.vars = FALSE) 

tmap_mode("plot") 
#because the red fill is just covering the name of the state, sometimes the name still shows slightly

tmap_mode("view")
#I think the order doesn't matter as much in view mode because the text shows over the fill so the red state's name shows up
#I got the popups to only show the state acronym and name 
#still working on changing the number at the top and making the popup not appear for the red state
#not sure how much I should worry about getting everything to work in view mode vs plot mode


#features to add:
#allow user to guess a state and check if their answer is right
#show correct answer
#show fun facts about that state (might want user to be able to match fun facts to the state)
#list famous places in that state (could put dots on map at their locations and have the user guess them too)
#allow user to guess name of states based on state bird/flag 
#allow user to match state bird/flag to state (not sure if this feature would be better with or without state names showing. maybe it can be up to the user)

#Useful URLs:
#About Leaflet, https://rstudio.github.io/leaflet/shapes.html 
#Zev Ross's blog about tmap, http://zevross.com/blog/2018/10/02/creating-beautiful-demographic-maps-in-r-with-the-tidycensus-and-tmap-packages/#adding-additional-layers-to-the-map
#Shiny tutorial: https://shiny.rstudio.com/tutorial/
#Git tutorial: https://www.youtube.com/watch?v=0fKg7e37bQE



