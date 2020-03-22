library(dplyr)
library(ggplot2)
library(leaflet)
library(plotly)
library(RPostgreSQL)
library(scales)
library(shiny)
library(shinyWidgets)
library(stringr)
library(tidyr)
library(RColorBrewer)
library(ggthemes)

# Connection
con <- dbConnect(drv = dbDriver('PostgreSQL'),
                 dbname = 'sfhqxipq',
                 host = 'drona.db.elephantsql.com',
                 user = 'sfhqxipq', password = 'Bq8j2SGQXNAUQiZJ-nOXp7BjNey_a2N3')

# Data
  #list of zipcodes
zips <- dbGetQuery(con, "SELECT DISTINCT zip_code FROM customer ORDER BY 1")
  
  #zip_code locations
z <- read.csv('ziploc.csv')
m <- read.csv('map.csv')

# Password
pwd6 <- '1995'

# Execute upon Close
onStop(function()
  {
    dbDisconnect(con)
    rm(list = ls())
    cat('Have fun!')
  }
)
