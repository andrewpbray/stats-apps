library(shiny)
library(ggplot2)
library(oilabs)
library(dplyr)

shinyServer(function(input, output) {

  ###### INITIALIZE REACTIVE VALUES ######
  vals <- reactiveValues(
    original_data = data_frame(),
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

    old_resamples <- vals$all_resamples
    new_resamples <- rep_sample_n(od, nrow(od), replace = TRUE, reps = n_reps)

    if(nrow(old_resamples)) {
      n_reps <- max(old_resamples$replicate)
    } else {
      n_reps <- 0
    }

    new_resamples <- new_resamples %>%
      ungroup() %>%
      mutate(replicate = replicate + n_reps) %>%
      group_by(replicate)

    vals$last_resamples <- new_resamples
    vals$all_resamples <- bind_rows(old_resamples, new_resamples)
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

    if(nrow(all_summaries) <= 70) {
      d <- ggplot(all_summaries, aes(x = prop_heads)) +
        geom_dotplot(binwidth = 0.05, method = "histodot") +
        theme(legend.position = "none") +
        xlim(c(0, 1)) +
        scale_y_continuous(name = "", breaks = NULL)

      return(d)
    }

    ggplot(all_summaries, aes(x = prop_heads)) +
      geom_histogram(binwidth = 0.05, fill = "black", color = "black") +
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
    vals$last_resamples
  })

  output$last_resamples_summary <- renderPrint({
    last_resamples_summary()
  })

  ###### HELP MODAL ######
  observeEvent(input$help_button, {
    showModal(modalDialog(
      title = "Instructions",
      HTML(
        "<ol><li>Select the number of coin flips and probability of flipping <em>Heads</em></li>",
        "<li>Press <em>Regenerate Original Data</em> to flip the coin and generate data from which you will resample</li>",
        "<li>Select the number of resamples you which to take from the original data</li>",
        "<li>Press <em>Resample!</em> to take bootstrap samples from the original data</li>"
      )
    ))
  })
})
