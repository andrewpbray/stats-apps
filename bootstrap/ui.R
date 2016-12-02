library(shiny)
library(shinydashboard)

dashboardPage(
  dashboardHeader(title = "Understanding the Bootstrap", titleWidth = 300),
  dashboardSidebar(disable = TRUE),
  dashboardBody(
    fluidRow(
      box(width = 3,
          numericInput("n_flips", "Number of Flips", 10,
                       min = 1, max = 1000, step = 1
          ),
          numericInput("p_heads", "Probability of Heads", 0.5,
                       min = 0, max = 1, step = 0.05
          ),
          actionButton("flip_coin_button", "Regenerate Original Data (Clear All)", width = "100%"),
          hr(),
          selectInput("n_resamples", "Number of Resamples", c(1, 10, 100, 1000), selected = 10),
          actionButton("bootstrap_button", "Resample!", width = "100%"),
          hr(),
          actionButton("help_button", "Help", width = "100%")
      ),
      box(width = 3, title = "Original Data",
          verbatimTextOutput("original_data"),
          verbatimTextOutput("original_data_summary")
      ),
      box(width = 3, title = "Bootstrapped Proportions",
          plotOutput("bootstrap_dotplot")
      ),
      box(width = 3, title = "Last Resample(s)",
          verbatimTextOutput("last_resamples"),
          verbatimTextOutput("last_resamples_summary")
      )
    )
  )
)
