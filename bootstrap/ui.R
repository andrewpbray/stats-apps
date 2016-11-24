library(shiny)
library(shinydashboard)

dashboardPage(
  dashboardHeader(title = "Understanding the bootstrap", titleWidth = 300),
  dashboardSidebar(width = 300,
                   numericInput("n_flips", "Number of Flips", 10,
                                min = 1, max = 1000, step = 1
                   ),
                   numericInput("p_heads", "Probability of Heads", 0.5,
                                min = 0, max = 1, step = 0.05
                   ),
                   actionButton("flip_coin_button", "Generate Original Data"),
                   actionButton("bootstrap_button", "Take Bootstrap Sample")
  ),
  dashboardBody(
    fluidRow(
      box(width = 6, title = "Bootstrap dotplot of proportion",
          plotOutput("bootstrap_dotplot", height = 600)
      ),
      box(width = 3, title = "Original sample",
          verbatimTextOutput("original_data"),
          verbatimTextOutput("original_summary")
      ),
      box(width = 3, title = "Bootstrap sample",
          verbatimTextOutput("bootstrap_data"),
          verbatimTextOutput("bootstrap_summary")
      )
    )
  )
)
