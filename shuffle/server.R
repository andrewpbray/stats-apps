library(shiny)
library(ggplot2)
library(dplyr)

shinyServer(function(input, output) {

  ###### INITIALIZE REACTIVE VALUES ######
  vals <- reactiveValues(
    all_shuffled_data = data_frame(),
    last_shuffled_data = data_frame()
  )

  ###### DISPLAY ORIGINAL DATA AND SUMMARY ######
  output$original_data <- renderPrint({
    original_data %>%
      as.data.frame()
  })

  output$original_data_summary <- renderPrint({
    original_data %>%
      summarize_results() %>%
      as.data.frame
  })

  ###### SHUFFLED DATA AND SUMMARY ######
  observeEvent(input$shuffle_button, {

    # iterate over the rest of this code (doesn't work in for loop?)
    new_results <- original_data %>%
      shuffle_data() %>%
      summarize_results() %>%
      filter(treatment == "dolphins", response == "improved") %>%
      mutate(current = TRUE)

    results <- vals$all_shuffled_data %>%
      mutate(current = FALSE) %>%
      bind_rows(new_results)

    results$current[results$n == new_results$n] <- TRUE

    vals$all_shuffled_data <- results
    vals$last_shuffed_data <- new_results
  })

  last_shuffled_data_summary <- reactive({
    lsd <- vals$last_shuffled_data
    if(!nrow(lsd)) return(NULL)

    lsd %>% summarize_results()
  })

  all_shuffled_data_summary <- reactive({
    vals$all_shuffled_data %>%
      summarize_results()
  })

  ###### SHUFFLED DATA OUTPUT ######
  output$last_shuffled_data <- renderPrint({
    #browser()
    vals$last_shuffled_data
  })

  output$last_shuffled_data_summary <- renderPrint({
    last_shuffled_data_summary()
  })

  ###### SHUFFLED DATA PLOT #######
  output$shuffled_data_plot <- renderPlot({
    asd <- vals$all_shuffled_data
    validate(need(nrow(asd) > 0, message = "Press 'Shuffle!' to get started!"))

    print(asd)
    ggplot(asd, aes(x = n, fill = current)) +
      geom_dotplot(binwidth = 0.5) +
      xlim(c(3, 11)) +
      theme(legend.position = "none")
  })

  ###### HELP MODAL ######
  observeEvent(input$help_button, {
    showModal(modalDialog(
      title = "Instructions",
      HTML(
        "Instructions TBD"
      )
    ))
  })
})
