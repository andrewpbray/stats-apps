library(shiny)
library(ggplot2)
library(dplyr)

shinyServer(function(input, output) {

  flips_orig <- reactive({

    input$flip_coin_button

    isolate({
      n_flips <- input$n_flips
      p_heads <- input$p_heads
    })

    probs <- c(p_heads, 1 - p_heads)
    flips <- sample(c("H", "T"), size = n_flips, replace = TRUE, prob = probs)

    data_frame(
      flip_num = seq_along(flips),
      flip = flips
    )
  })

  flips_boot <- reactive({
    input$bootstrap_button
    dplyr::sample_frac(flips_orig(), replace = TRUE)
  })

  output$bootstrap_dotplot <- renderPlot({
    flips <- flips_boot()
    flips_summary <- summarize_flips(flips)

    ggplot(flips_summary, aes(x = prop_heads)) +
      geom_dotplot(binwidth = 0.05) +
      theme(legend.position = "none") +
      xlim(c(0, 1))
  })

  output$original_data <- renderPrint({
    print(flips_orig())
  })

  output$original_summary <- renderPrint({
    summarize_flips(flips_orig())
  })

  output$bootstrap_data <- renderPrint({
    print(flips_boot())
  })

  output$bootstrap_summary <- renderPrint({
    summarize_flips(flips_boot())
  })
})
