library(shiny)
library(ggplot2)
library(oilabs)
library(dplyr)

shinyServer(function(input, output) {

  ###### INITIALIZE REACTIVE VALUES ######
  vals <- reactiveValues(
    original_data =- data_frame(),
    last_resamples = data_frame(),
    all_resamples = data_frame()
  )

  ###### ORIGINAL FLIPS + SUMMARY ######
  observe({
    input$flip_coin_button

    # If coin is flipped, clear all
    vals$last_resamples <- data_frame()
    vals$all_resamples <- data_frame()

    isolate({
      n_flips <- input$n_flips
      p_heads <- input$p_heads
    })

    probs <- c(p_heads, 1 - p_heads)
    flips <- sample(c("H", "T"), size = n_flips, replace = TRUE, prob = probs)

    vals$original_data <- data_frame(
      flip_num = seq_along(flips),
      flip = flips
    )
  })

  original_data_summary <- reactive({
    summarize_flips(vals$original_data)
  })

  ###### BOOTSTRAPPED FLIPS + SUMMARY ######
  observeEvent(input$bootstrap_button, {
    od <- vals$original_data
    n_reps <- input$n_resamples
    vals$last_resamples <- rep_sample_n(od, nrow(od), replace = TRUE, reps = n_reps)
    vals$all_resamples <- bind_rows(vals$all_resamples, vals$last_resamples)
  })

  last_resamples_summary <- reactive({
    summarize_flips(vals$last_resamples)
  })

  all_resamples_summary <- reactive({
    summarize_flips(vals$all_resamples)
  })

  ###### DOTPLOT OF BOOTSTRAPPED PROPORTIONS ######
  output$bootstrap_dotplot <- renderPlot({
    all_summaries <- all_resamples_summary()
    validate(need(
      nrow(all_summaries) > 0,
      message = "Click 'Resample!' to get started!"
    ))

    ggplot(all_summaries, aes(x = prop_heads)) +
      geom_dotplot(binwidth = 0.05) +
      theme(legend.position = "none") +
      xlim(c(0, 1))
  })

  ###### PRINT SUMMARIES ######
  output$original_data <- renderPrint({
    vals$original_data
  })

  output$original_data_summary <- renderPrint({
    original_data_summary()
  })

  output$last_resamples <- renderPrint({
    lr <- vals$last_resamples
    validate(need(nrow(lr) > 0, message = ""))
    lr
  })

  output$last_resamples_summary <- renderPrint({
    res <- summarize_flips(vals$last_resamples)
    validate(need(nrow(res) > 0, message = ""))
    res
  })

  ###### HELP MODAL ######
  observeEvent(input$help_button, {
    showModal(modalDialog(
      title = "Instructions",
      HTML(
        "<ol><li>Select the number of coin flips you wish to perform as well as the probability of flipping 'Heads'</li>",
        "<li>Press the 'Generate Original Data' button to flip the coin and generate data from which bootstrapped samples will be taken</li>",
        "<li>Press the 'Take Bootstrap Sample' button to take a bootstrap sample from the original data</li>"
      )
    ))
  })
})
