library(shiny)
library(shinydashboard)

dashboardPage(
  dashboardHeader(title = "Understanding the bootstrap", titleWidth = 300),
  dashboardSidebar(width = 300),
  dashboardBody(
    fluidRow(
      column(width = 7,
             box(width = 12, title = "Bootstrap dotplot of proportion",
                 plotOutput("test_plot1", height = 600)
             )
      ),
      column(width = 5,
             box(width = 12, title = "Original sample",
                 plotOutput("test_plot2", height = 250)
             ),
             box(width = 12, title = "Bootstrap sample",
                 plotOutput("test_plot3", height = 250)
             )
      )
    )
  )
)
