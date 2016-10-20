library(shiny)
library(ggplot2)
library(dplyr)
library(openintro)
library(broom)

shinyServer(function(input, output) {

  dat <- reactive({

    # Subset data
    set.seed(100)
    bdims %>%
      select(hgt, wgt) %>%
      sample_n(input$n)
  })

  dat_summary <- reactive({

    # Compute summary values on data
    dat() %>%
      summarize(N = n(), mean_hgt = mean(hgt), mean_wgt = mean(wgt)) %>%
      mutate_(slope = input$sl) %>% # Don't use NSE
      mutate(intercept = mean_wgt - slope * mean_hgt)
  })

  dat_plus <- reactive({

    # Make linear function
    f <- make_fun(
      intercept = dat_summary()$intercept,
      slope = dat_summary()$slope
    )

    # Add "fitted" values to data
    dat() %>%
      mutate(.fitted = f(hgt))
  })

  output$the_plot <- renderPlot({

    # Generate plot
    g <- ggplot(data = dat_plus(), aes(x = hgt, y = wgt)) +
      lims(x = c(145, 200), y = c(40, 118)) +
      geom_point() +
      geom_abline(data = dat_summary(),
                  aes(intercept = intercept, slope = slope),
                  color = "dodgerblue") +
      geom_point(data = dat_summary(),
                 aes(x = mean_hgt, y = mean_wgt),
                 color = "red", size = 3) +
      geom_segment(aes(xend = hgt, yend = .fitted),
                   arrow = arrow(length = unit(0.1, "cm")),
                   size = 0.5, color = "darkgray") +

      if(TRUE) {
        g <- g +
          geom_abline(data = dat_summary(),
                      aes(intercept = 80, slope = 0),
                      color = "dodgerblue")
      }

    g
  })
})
