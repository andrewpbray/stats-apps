library(shiny)
library(shinydashboard)

dashboardPage(
  dashboardHeader(title = "Find the best fit line"),
  dashboardSidebar(
    sliderInput("n",
                "Number of points:",
                min = 2,
                max = 507,
                value = 20
    ),
    sliderInput("sl",
                "Slope of line:",
                min = min(sl_poss),
                max = max(sl_poss),
                value = 2,
                step = 0.25
    ),
    checkboxInput("show_best_fit", "Show best fit line"),
    checkboxInput("show_residuals", "Show residuals")
  ),
  dashboardBody(
    fluidRow(
      box(width = 6,
          plotOutput("the_plot")
      ),
      box(width = 6,
          plotOutput("ss_curve")
      )
    )
  )
)
