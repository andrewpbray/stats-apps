library(dplyr)

flip_coin <- function(n_flips = 10, p_heads = 0.6) {
  probs <- c(p_heads, 1 - p_heads)
  flips <- sample(c("H", "T"), size = n_flips, replace = TRUE, prob = probs)

  data_frame(
    flip_num = seq_along(flips),
    flip = flips
  )
}

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
