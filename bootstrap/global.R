library(dplyr)

summarize_flips <- function(flips) {
  if("replicate" %in% names(flips)) {
    flips <- flips %>% group_by(replicate)
  }
  flips %>%
    summarize(
      n_heads = sum(flip == "H"),
      n_flips = n(),
      prop_heads = n_heads/n_flips
    )
}
