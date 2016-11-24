library(dplyr)

summarize_flips <- function(flips) {
  flips %>%
    summarize(
      n_heads = sum(flip == "H"),
      n_flips = n(),
      prop_heads = n_heads/n_flips
    )
}

set.seed(234)
flips_orig <- flip_coin(10, p_heads = 0.65)
flips_orig
summarize_flips(flips_orig)
