library(shiny)

shinyUI(fluidPage(

  titlePanel("Find the best fit line"),

  sidebarLayout(
    sidebarPanel(
      sliderInput("n",
                  "Number of points:",
                  min = 2,
                  max = 507,
                  value = 20
      ),
      sliderInput("sl",
                  "Slope of line:",
                  min = -2,
                  max = 5,
                  value = 2,
                  step = 0.25
      ),
      checkboxInput("show_best_fit", "Show best fit line"),
      checkboxInput("show_residuals", "Show residuals")
    ),

    mainPanel(
      plotOutput("the_plot")
    )
  )
))
