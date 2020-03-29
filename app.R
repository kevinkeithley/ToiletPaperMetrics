#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)

# Define UI for application
ui <- fluidPage(
  
  # Custom CSS Styling for font size and line height
  tags$head(
    tags$style(HTML("
    
        p, #how_long, #how_many, li {
            font-size: 16px;
            line-height: 1.5;
        }
                
    "))
  ),
   
   # Application title
   titlePanel("The case of the TP hoarder"),
   
   # Sidebar 
   sidebarLayout(position = "right",
      sidebarPanel(
         numericInput("cases",
                      "Number of TP cases:",
                      min = 1,
                      max = 10,
                      value = 4),
         numericInput("rolls",
                     "Rolls per case:",
                     min = 2,
                     max = 40,
                     value = 30),
         numericInput("sheets_roll",
                     "Sheets per roll:",
                     min = 300,
                     max = 1000,
                     value = 425),
         hr(),
         sliderInput("sheets_shit",
                     "Sheets per shit:",
                     min = 4,
                     max = 40,
                     value = 20),
         sliderInput("shits",
                     "Shits per week (per person):",
                     min = 2,
                     max = 28,
                     value = 7),
         hr(),
         numericInput("people",
                      "People in household:",
                      min = 1,
                      value = 4),
         sliderInput("weeks",
                     "Quarantine period (weeks)",
                     min = 1,
                     max = 26,
                     value = 8)
      ),
      
      # Main Panel
      mainPanel(
         fluidRow(
           column(12,
                  p("I was inspired to create this app after seeing the Facebook video of 'Dad does maths behind toilet paper panic buying'.",tags$a(href="https://www.facebook.com/news.com.au/videos/dad-does-maths-behind-toilet-paper-panic-buying/2798341280203666/","Link to video")),
                  p("The default values in this app roughly correlate with the Costco example in the video, but with a few more abilities. The app lets you address two related questions:"),
                  tags$ol(
                    tags$li("Given a supply of toilet paper and shitting statistics, how long will your toilet paper last?"),
                    tags$li("Given a supply of toilet paper, shitting statistics, and a quarantine period, how many shits can you take and not run out of toilet paper?")
                  ),
                  p("Armed with your new knowledge, may you spend more time inside with your family, and less time in public stockpiling things you don't need.")
                  )
         ),
         hr(),
         fluidRow(
           column(6,
                  icon("calendar", "fa-3x", lib = "font-awesome"),
                  h3("How long will my toilet paper last?"),
                  p(textOutput("how_long"))),
           column(6,
                  icon("poop", "fa-3x", lib = "font-awesome"),
                  h3("How many shits can I take?"),
                  textOutput("how_many"))
         ),
         hr(),
         fluidRow(
           column(12,
                  tags$a(href="https://github.com/kevinkeithley/ToiletPaperMetrics", "Project files"),
                  " available on GitHub ",
                  icon("github","fa-2x",lib = "font-awesome")
                  )
         ),
         fluidRow(
           column(12,
                  "App built with ",
                  tags$a(href="https://shiny.rstudio.com", "Shiny"),
                  " from ",
                  tags$a(href="https://rstudio.com/", "RStudio")
           )
         ),
         fluidRow(
           column(12,
                  "Copyright ",
                  icon("copyright"), 
                  " 2020 Kevin Keithley, MIT License"
           ))
      )
   )
)

# Define server logic
server <- function(input, output) {
  
  # Create reactive variables for assumptions
  
  
  total_sheets_react <- reactive({
    (input$cases*input$rolls*input$sheets_roll)
  })
  # Calculate how many shits you can take for the selected quarantine period
  how_many_react <- reactive({
    total_sheets_react()/(input$sheets_shit*input$people*input$weeks)
  })
  # Calculate how long your stash of toilet paper will last
  how_long_react <- reactive({
    total_sheets_react()/(input$sheets_shit*input$people*input$shits)
  })
  
  # Create render functions
  output$how_many <- renderText({
    paste("Each person can take ",
          round(how_many_react(), digits = 1),
          " shit(s) per week for the course of the selected quarantine period of ",
          input$weeks,
          " week(s).")
    })
  output$how_long <- renderText({
    paste("Your stash of toilet paper will last ",
          round(how_long_react(), digits = 1),
          " weeks.")
  })
}

# Run the application 
shinyApp(ui = ui, server = server)

