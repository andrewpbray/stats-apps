library(dplyr)

summarize_flips <- function(flips) {

  if(!is.null(flips$replicate)) {
    flips <- flips %>% group_by(replicate)
  }
  flips %>%
    summarize(
      n_heads = sum(flip == "H"),
      n_flips = n(),
      prop_heads = n_heads/n_flips
    )
}

save_summary <- function(this_summary) {
  if(exists("all_summaries")) {
    all_summaries <<- bind_rows(all_summaries, this_summary)
  } else {
    all_summaries <<- this_summary
  }
}

# set.seed(234)
# flips_orig <- flip_coin(10, p_heads = 0.65)
# flips_orig
# summarize_flips(flips_orig)
