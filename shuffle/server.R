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

  # something here...

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
