library(shiny)
library(ggplot2)
library(dplyr)

shinyServer(function(input, output) {

  flips_boot <- reactive({
    input$flip_coin_button
    dplyr::sample_frac(flips_orig, replace = TRUE)
  })

  output$bootstrap_dotplot <- renderPlot({
    flips <- flips_boot()
    flips_summary <- summarize_flips(flips)

    ggplot(flips_summary, aes(x = prop_heads)) +
      geom_dotplot() +
      theme(legend.position = "none") +
      xlim(c(0, 1))
  })

  output$original_data <- renderPrint({
    print(flips_orig)
  })

  output$original_summary <- renderPrint({
    summarize_flips(flips_orig)
  })

  output$bootstrap_data <- renderPrint({
    print(flips_boot())
  })

  output$bootstrap_summary <- renderPrint({
    summarize_flips(flips_boot())
  })
})
