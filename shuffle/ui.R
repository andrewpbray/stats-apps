library(shiny)
library(shinydashboard)

dashboardPage(
  dashboardHeader(title = "Understanding Randomization", titleWidth = 300),
  dashboardSidebar(disable = TRUE),
  dashboardBody(
    fluidRow(
      box(width = 12,
          actionButton("shuffle_button", HTML("<b>Shuffle!</b>"),
                       width = "100%", icon = icon("random")),
          actionButton("help_button", "Help", width = "100%", icon = icon("question"))
      )
    ),
    fluidRow(
      box(width = 4,
          h4("Original Data"),
          verbatimTextOutput("original_data"),
          h4("Summary"),
          verbatimTextOutput("original_data_table")
      ),
      box(width = 4,
          h4("Last Shuffled Data"),
          verbatimTextOutput("last_shuffled_data"),
          h4("Summary"),
          verbatimTextOutput("last_shuffled_data_table")
      ),
      box(width = 4, title = "Dolphins Improved in Shuffled Data",
          plotOutput("shuffled_data_plot")
      )
    )
  )
)
