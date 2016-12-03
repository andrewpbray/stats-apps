library(ggplot2)
library(dplyr)

original_data <- readr::read_tsv("data/dolphins.tsv") %>%
  rename(treatment = EV, response = RV)

shuffle_data <- function(x) {
  x %>%
    mutate(response = sample(response))
}

summarize_results <- function(x) {

  if("rep" %in% names(x)) {
    x <- x %>% group_by(rep, treatment, response)
  } else {
    x <- x %>% group_by(treatment, response)
  }
  x %>% summarize(n = n())
}
