# Load packages -----------------------------------------------------
library(shiny)
library(shinydashboard)
library(glue)
library(tidyverse)

# Load data ---------------------------------------------------------
load("data/movies.Rdata")

# Load helpers ------------------------------------------------------
source("helpers.R")

# Define UI ---------------------------------------------------------
ui <- dashboardPage(
  
  # Header
  dashboardHeader(title = "Movie Browser"),
  
  # Sidebar
  dashboardSidebar(
    sidebarMenu(
      menuItem("Home", tabName = "home", icon = icon("home")),
      menuItem("Subset", tabName = "subset", icon = icon("cut"))
    )
  ),
  
  # Body
  dashboardBody(
    tabItems(
      
      # Tab 1
      tabItem(
        tabName = "home",
        fluidRow(
          # Value box: sample size
          valueBox(
            nrow(movies), 
            "Movies", 
            icon = icon("film")
          )
        ),
        # Data reference
        h4("The data come from IMDB and Rotten Tomatoes on a random sample of 
        movies released in the US between 1970 and 2014")
      ),
      
      # Tab 2
      tabItem(
        tabName = "subset"
      )
    )
  )
)

# Define server function --------------------------------------------
server <- function(input, output) {}

# Create the Shiny app object ---------------------------------------
shinyApp(ui, server)
