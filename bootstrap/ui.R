library(shiny)
library(shinydashboard)

dashboardPage(
  dashboardHeader(title = "Understanding the bootstrap", titleWidth = 300),
  dashboardSidebar(disable = TRUE),
  dashboardBody(
    fluidRow(
      box(width = 2,
          numericInput("n_flips", "Number of Flips", 10,
                       min = 1, max = 1000, step = 1
          ),
          numericInput("p_heads", "Probability of Heads", 0.5,
                       min = 0, max = 1, step = 0.05
          ),
          actionButton("flip_coin_button", "Generate Original Data", width = "100%"),
          actionButton("bootstrap_button", "Take Bootstrap Sample", width = "100%"),
          hr(),
          helpText(HTML(
            "<h4>Instructions</h4>",
            "<ol><li>Select the number of coin flips you wish to perform as well as the probability of flipping 'Heads'</li>",
            "<li>Press the 'Generate Original Data' button to flip the coin and generate data from which bootstrapped samples will be taken</li>",
            "<li>Press the 'Take Bootstrap Sample' button to take a bootstrap sample from the original data</li>"
          ))
      ),
      box(width = 3, title = "Original sample",
          verbatimTextOutput("original_data"),
          verbatimTextOutput("original_summary")
      ),
      box(width = 4, title = "Bootstrap dotplot of proportion",
          plotOutput("bootstrap_dotplot")
      ),
      box(width = 3, title = "Last bootstrap sample",
          verbatimTextOutput("bootstrap_data"),
          verbatimTextOutput("bootstrap_summary")
      )
    )
  )
)
