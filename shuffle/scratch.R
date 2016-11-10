# modelled after http://www.rossmanchance.com/applets/ChiSqShuffle.html?dolphins=1&count=1

library(ggplot2)
library(dplyr)

dat <- readr::read_tsv("shuffle/data/dolphins.tsv") %>%
  rename(treatment = EV, response = RV)

shuffle_data <- function(x) {
  dat %>%
    mutate(response = sample(response))
}

summarize_results <- function(x) {
  x %>%
    group_by(treatment, response) %>%
    summarize(n = n())
}

# initialize results
results <- data_frame()

# iterate over the rest of this code (doesn't work in for loop?)
new_results <- dat %>%
  shuffle_data() %>%
  summarize_results() %>%
  filter(treatment == "dolphins", response == "improved") %>%
  mutate(current = TRUE)
new_results

results <- results %>%
  mutate(current = FALSE) %>%
  bind_rows(new_results)

results$current[results$n == new_results$n] <- TRUE
results

ggplot(results, aes(x = n, fill = current)) +
  geom_dotplot() +
  xlim(c(4, 10)) +
  theme(legend.position = "none")
