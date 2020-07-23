
# =====================================================================================
# "intial_setup.R" file                                                               |
#                                                                                     |   
# =====================================================================================

library(tigris)     # counties, places (cities), school_districts
library(dplyr)
library(sf)     
library(tmap)

options(tigris_class = "sf")  

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

tm_shape(us_states) + tm_polygons() + tm_shape(one_state) + tm_fill(col="red")

tm_shape(us_states) + tm_polygons() + tm_text("NAME") + tm_shape(one_state) + tm_fill(col="red")

#features to add:
#





