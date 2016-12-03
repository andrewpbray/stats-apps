library(shiny)
library(shinydashboard)

dashboardPage(
  dashboardHeader(title = "Understanding Randomization", titleWidth = 300),
  dashboardSidebar(disable = TRUE),
  dashboardBody(
    fluidRow(
      column(
        width = 4,
        box(width = 12,
            h4("Original Data"),
            verbatimTextOutput("original_data"),
            h4("Summary"),
            verbatimTextOutput("original_data_table"),
            actionButton("shuffle_button", HTML("<b>Shuffle!</b>"),
                         width = "100%", icon = icon("random")),
            actionButton("help_button", "Help", width = "100%", icon = icon("question"))
        )
      ),
      column(
        width = 4,
        box(width = 12,
            h4("Last Shuffled Data"),
            verbatimTextOutput("last_shuffled_data"),
            h4("Summary"),
            verbatimTextOutput("last_shuffled_data_table")
        )
      ),
      column(
        width = 4,
        box(width = 12, title = "Shuffled Data Plot",
            plotOutput("shuffled_data_plot")
        )
      )
    )
  )
)
