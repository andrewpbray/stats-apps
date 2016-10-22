library(shiny)
library(ggplot2)
library(dplyr)
library(openintro)
library(broom)
library(oilabs)

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

  all_ss <- reactive({

    isolate({
      int <- dat_summary()$intercept
    })

    nr <- nrow(dat())

    dat() %>%
      rep_sample_n(nr, reps = length(sl_poss), replace = FALSE) %>%
      ungroup() %>%
      mutate(slope = rep(sl_poss, each = nr),
             .fitted = make_fun(int, slope)(hgt)
      ) %>%
      group_by(slope) %>%
      summarize(ssr = sum((wgt - .fitted)^2))
  })

  output$the_plot <- renderPlot({

    # Generate plot
    g <- ggplot(data = dat_plus(), aes(x = hgt, y = wgt)) +
      geom_point() +
      geom_abline(data = dat_summary(),
                  aes(intercept = intercept, slope = slope),
                  color = "dodgerblue") +
      geom_point(data = dat_summary(),
                 aes(x = mean_hgt, y = mean_wgt),
                 color = "red", size = 3)

    # Show residuals?
    if(input$show_residuals) {
      g <- g +
        geom_segment(aes(xend = hgt, yend = .fitted),
                     arrow = arrow(length = unit(0.1, "cm")),
                     size = 0.5, color = "darkgray")
    }

    # Show best fit line?
    if(input$show_best_fit) {
      g <- g +
        geom_smooth(method = "lm", se = 0, formula = y ~ x,
                    color = "red", fullrange = TRUE)
    }

    g
  })

  output$ss_curve <- renderPlot({

    ss_df <- all_ss()

    sel <- ss_df %>%
      filter(slope == input$sl)

    ggplot(ss_df, aes(x = slope, y = ssr)) +
      geom_line() +
      geom_point(data = sel, aes(x = slope, y = ssr),
                 color = "red", fill = "red", size = 5, shape = 23)
  })
})
