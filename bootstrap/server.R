library(shiny)
library(ggplot2)
library(dplyr)

shinyServer(function(input, output) {

  ###### INITIALIZE REACTIVE VALUES ######
  vals <- reactiveValues(all_bootstrap_summaries = data_frame())

  ###### ORIGINAL FLIPS + SUMMARY ######
  flips_orig <- reactive({

    input$flip_coin_button

    # If coin is flipped, clear saved summaries
    vals$all_bootstrap_summaries <- data_frame()

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

  flips_orig_summary <- reactive({
    summarize_flips(flips_orig())
  })

  ###### BOOTSTRAPPED FLIPS + SUMMARY ######
  flips_boot <- eventReactive(input$bootstrap_button, {
    dplyr::sample_frac(flips_orig(), replace = TRUE)
  })

  flips_boot_summary <- reactive({
    summarize_flips(flips_boot())
  })

  ###### UPDATE SAVED BOOTSTRAP SUMMARIES ######
  observeEvent(input$bootstrap_button, {

    all_summaries <- vals$all_bootstrap_summaries
    this_summary <- flips_boot_summary()

    vals$all_bootstrap_summaries <- bind_rows(all_summaries, this_summary)
  })

  ###### DOTPLOT OF BOOTSTRAPPED PROPORTIONS ######
  output$bootstrap_dotplot <- renderPlot({
    all_summaries <- vals$all_bootstrap_summaries
    validate(need(nrow(all_summaries) > 0, message = "Click 'Take Bootstrap Sample' to get started!"))

    ggplot(all_summaries, aes(x = prop_heads)) +
      geom_dotplot(binwidth = 0.05) +
      theme(legend.position = "none") +
      xlim(c(0, 1))
  })

  ###### PRINT SUMMARIES ######
  output$original_data <- renderPrint({
    flips_orig()
  })

  output$original_summary <- renderPrint({
    flips_orig_summary()
  })

  output$bootstrap_data <- renderPrint({
    flips_boot()
  })

  output$bootstrap_summary <- renderPrint({
    flips_boot_summary()
  })
})
