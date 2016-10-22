library(ggplot2)
library(dplyr)
library(openintro)
library(broom)

# Define linear function
make_fun <- function(intercept, slope) {
  function(x) {
    intercept + x * slope
  }
}

# Possible slopes
sl_poss <- seq(-2, 7, by = 0.25)
