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

results <- data_frame()

new_results <- dat %>%
  shuffle_data() %>%
  summarize_results() %>%
  filter(treatment == "dolphins", response == "improved") %>%
  mutate(last = TRUE)
new_results

results <- results %>%
  mutate(last = FALSE) %>%
  bind_rows(new_results)
results

ggplot(results, aes(x = n, fill = last)) +
  geom_dotplot() +
  xlim(c(3, 9))
