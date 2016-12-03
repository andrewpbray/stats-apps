library(shiny)
library(ggplot2)
library(tidyr)
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

  output$original_data_table <- renderPrint({
    original_data %>%
      summarize_results() %>%
      spread(response, n)
  })

  ###### SHUFFLED DATA AND SUMMARY ######
  observeEvent(input$shuffle_button, {
    lsd <- vals$last_shuffled_data
    asd <- vals$all_shuffled_data

    # add rep column to keep track of different reps
    if(!nrow(asd)) {
      cnt <- 0
    } else {
      cnt <- max(asd$rep)
    }

    # create shuffled data
    lsd <- original_data %>%
      shuffle_data() %>%
      mutate(rep = cnt + 1) %>%
      select(rep, treatment, response)

    # update reactive vals
    vals$last_shuffled_data <- lsd
    vals$all_shuffled_data <- asd %>%
      bind_rows(lsd)
  })

  ###### SHUFFLED DATA OUTPUT ######
  output$last_shuffled_data <- renderPrint({
    lsd <- vals$last_shuffled_data
    if(!nrow(lsd)) return(data_frame())

    vals$last_shuffled_data %>%
      as.data.frame()
  })

  output$last_shuffled_data_table <- renderPrint({
    lsd <- vals$last_shuffled_data
    if(!nrow(lsd)) return(data_frame())

    lsd %>%
      summarize_results() %>%
      spread(response, n)
  })

  ###### SHUFFLED DATA PLOT #######
  all_successes <- reactive({
    asd <- vals$all_shuffled_data
    if(!nrow(asd)) return(NULL)

    asd %>%
      summarize_results() %>%
      filter(treatment == "dolphins", response == "improved")
  })

  output$shuffled_data_plot <- renderPlot({
    as <- all_successes()
    validate(need(as, message = "Press 'Shuffle!' to get started!"))

    print(as)

    ggplot(as, aes(x = n)) +
      geom_dotplot(binwidth = .5) +
      scale_x_continuous(breaks = 2:11, limits = c(2, 11)) +
      scale_y_continuous(name = "", breaks = NULL) +
      theme(legend.position = "none", panel.grid.minor = element_blank())
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
