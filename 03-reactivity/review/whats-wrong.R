library(shiny)

# UI ----
ui <- fluidPage(
  
  titlePanel("Let's do simple math!")
  
  sidebarLayout(
    
    sidebarPanel(
      
      sliderInput("x", 
                  "Select x", 
                  min = 1, max = 50, 
                  value = 30)
      
      numericInput("multiplier",
                   "Multiply by", 
                   min = 1, max = 50, 
                   value = 5),
    ),
    
    mainPanel( 
      textOutput("result") 
    )
    
  )
)

# Server ----
server <- function(input, output) {
  
  mult_3        <- function(x, multiplier) { x * multiplier }
  
  output$result <- renderText({ 
    mult_3(input$x, input$multiplier)
  })
}

# Create Shiny app object
shinyApp(ui, server)
