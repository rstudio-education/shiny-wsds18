# Load packages -----------------------------------------------------
library(shiny)
library(tidyverse)
library(NHANES)

# Define UI ---------------------------------------------------------
ui <- fluidPage(
  
  # Application title -----------------------------------------------
  titlePanel("NHANES explorer"),
  
  # Sidebar layout with a input and output definitions --------------
  sidebarLayout(
    
    # Inputs: Select variables to plot ------------------------------
    sidebarPanel(
      
      # Select education levels -------------------------------------
      checkboxGroupInput(inputId = "education",
                         label = "Select education level(s):",
                         choices = levels(NHANES$Education),
                         selected = "College Grad"),
      
      # Horizontal line for visual separation -----------------------
      hr(),
      
      # Select variable for y-axis ----------------------------------
      selectInput(inputId = "y", 
                  label = "Y-axis:",
                  choices = c("Age", "Poverty", "Pulse", "AlcoholYear", "BPSysAve"), 
                  selected = "BPSysAve"),
      
      # Select variable for x-axis ----------------------------------
      selectInput(inputId = "x", 
                  label = "X-axis:",
                  choices = c("Age", "Poverty", "Pulse", "AlcoholYear", "BPDiaAve"), 
                  selected = "BPDiaAve"),
      
      # Select variable for color -----------------------------------
      selectInput(inputId = "z", 
                  label = "Color by:",
                  choices = c("Gender", "Depressed", "SleepTrouble", "SmokeNow", "Marijuana"),
                  selected = "SleepTrouble"),
      
      # Set alpha level ---------------------------------------------
      sliderInput(inputId = "alpha", 
                  label = "Alpha:", 
                  min = 0, max = 1, 
                  value = 0.5),
      
      # Add checkbox
      checkboxInput(inputId = "showdata",
                    label = "Show data table",
                    value = TRUE)
    ),
    
    # Output: --------------------------------------------------------
    mainPanel(
      # Show scatterplot --------------------------------------------
      plotOutput(outputId = "scatterplot"),
      br(),          # a little bit of visual separation
      # Print number of obs plotted ---------------------------------
      uiOutput(outputId = "n"),
      br(), br(),    # a little bit of visual separation
      # Show data table ---------------------------------------------
      DT::dataTableOutput(outputId = "nhanestable", height = 500)
    )
  )
)

# Define server function required to create the scatterplot ---------
server <- function(input, output) {
  
  # Create a subset of data filtering for selected title types ------
  NHANES_subset <- reactive({
    req(input$education) # ensure availablity of value before proceeding
    filter(NHANES, Education %in% input$education)
  })
  
  # Create scatterplot object the plotOutput function is expecting --
  output$scatterplot <- renderPlot({
    ggplot(data = NHANES_subset(), aes_string(x = input$x, y = input$y,
                                     color = input$z)) +
      geom_point(alpha = input$alpha)
  })
  
  # Print number of participants plotted ----------------------------------
  output$n <- renderUI({
    types <- NHANES_subset()$Education %>% 
      factor(levels = input$education) 
    counts <- table(types)
    
    HTML(paste("There are", counts, "participants with",
               input$education, "degree in this dataset. <br>"))
  })
  
  # Print data table if checked -------------------------------------
  output$nhanestable <- DT::renderDataTable({
    if(input$showdata){
      DT::datatable(data = NHANES[, 1:7], 
                    options = list(pageLength = 10, rownames = FALSE) 
      )  
    }
  })
  
}

# Create the app object ---------------------------------------------
shinyApp(ui = ui, server = server)
