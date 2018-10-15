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
          ),
          # Value box: avg IMDB rating
          valueBox(
            round(mean(movies$imdb_rating), 2),
            "Avg IMDB score",
            icon = icon("thumbs-up", lib = "glyphicon"),
            color = "fuchsia"
          ),
          # Value box: number of Oscar wins
          valueBox(
            sum(movies$best_pic_win == "yes"),
            "Oscar wins",
            icon = icon("trophy"),
            color = "yellow"
          )
        ),
        # Data reference
        h4("The data come from IMDB and Rotten Tomatoes on a random sample of 
           movies released in the US between 1970 and 2014")
        ),
    
    # Tab 2
    tabItem(
      tabName = "subset",
      # Row 1
      fluidRow(
        # Box: Select title type
        box(
          title = "Select title type", 
          status = "warning", 
          solidHeader = TRUE,
          "Select a title type using the drop down menu below.",
          selectInput(inputId = "title_type", 
                      label = "Title type:",
                      choices = unique(movies$title_type), 
                      selected = "Feature Film")
        )
      )
    )
  )
)
)

# Define server function --------------------------------------------
server <- function(input, output) {}

# Create the Shiny app object ---------------------------------------
shinyApp(ui, server)
