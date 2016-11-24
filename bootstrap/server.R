library(shiny)
library(ggplot2)

shinyServer(function(input, output) {

  output$test_plot1 <- renderPlot({

    ggplot(mtcars, aes(x = mpg)) +
      geom_dotplot() +
      theme(legend.position = "none")
  })

  output$test_plot2 <- renderPlot({

    ggplot(mtcars, aes(x = mpg)) +
      geom_dotplot() +
      theme(legend.position = "none")
  })

  output$test_plot3 <- renderPlot({

    ggplot(mtcars, aes(x = mpg)) +
      geom_dotplot() +
      theme(legend.position = "none")
  })
})
