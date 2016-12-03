library(shiny)
library(shinydashboard)

dashboardPage(
  dashboardHeader(title = "Understanding Randomization", titleWidth = 300),
  dashboardSidebar(disable = TRUE),
  dashboardBody(
    fluidRow(
      box(width = 3,
          actionButton("shuffle_button", HTML("<b>Shuffle!</b>"),
                       width = "100%", icon = icon("random")),
          actionButton("help_button", "Help", width = "100%", icon = icon("question"))
      ),
      box(width = 3,
          h4("Original Data"),
          verbatimTextOutput("original_data"),
          h4("Summary"),
          verbatimTextOutput("original_data_summary")
      )
      # box(width = 3, title = "Bootstrapped Proportions",
      #     plotOutput("bootstrap_dotplot")
      # ),
      # box(width = 3, title = "Last Resample(s)",
      #     verbatimTextOutput("last_resamples"),
      #     verbatimTextOutput("last_resamples_summary")
      # )
    )
  )
)
