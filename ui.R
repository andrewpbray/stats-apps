library(shiny)

shinyUI(fluidPage(

  titlePanel("Finding the best fit line"),

  sidebarLayout(
    sidebarPanel(
      sliderInput("bins",
                  "Something here:",
                  min = 1,
                  max = 50,
                  value = 30)
    ),

    mainPanel(
      plotOutput("the_plot")
    )
  )
))
