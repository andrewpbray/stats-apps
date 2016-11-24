library(shiny)
library(shinydashboard)

dashboardPage(
  dashboardHeader(title = "Understanding the bootstrap", titleWidth = 300),
  dashboardSidebar(width = 300,
                   numericInput("n_flips", "# Flips", 10,
                                min = 1, max = 1000, step = 1
                   ),
                   actionButton("flip_coin_button", "Flip Coin!")
  ),
  dashboardBody(
    fluidRow(
      column(width = 7,
             box(width = 12, title = "Bootstrap dotplot of proportion",
                 plotOutput("bootstrap_dotplot", height = 600)
             )
      ),
      column(width = 5,
             box(width = 12, title = "Original sample",
                 verbatimTextOutput("original_data"),
                 verbatimTextOutput("original_summary")
             ),
             box(width = 12, title = "Bootstrap sample",
                 verbatimTextOutput("bootstrap_data"),
                 verbatimTextOutput("bootstrap_summary")
             )
      )
    )
  )
)
