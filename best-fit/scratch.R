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

###############

# Set inputs
n <- 10
sl <- 3

# Subset data
set.seed(100)
dat <- bdims %>%
  select(hgt, wgt) %>%
  sample_n(n)

# Compute summary values on data
dat_summary <- dat %>%
  summarize(N = n(), mean_hgt = mean(hgt), mean_wgt = mean(wgt)) %>%
  mutate(slope = sl, intercept = mean_wgt - slope * mean_hgt)

# Make linear function
f <- make_fun(intercept = dat_summary$intercept, slope = dat_summary$slope)

# Add "fitted" values to data
dat <- dat %>%
  mutate(.fitted = f(hgt))

# Generate plot
ggplot(data = dat, aes(x = hgt, y = wgt)) +
  geom_point() +
  geom_abline(data = dat_summary,
              aes(intercept = intercept, slope = slope),
              color = "dodgerblue") +
  geom_point(data = dat_summary,
             aes(x = mean_hgt, y = mean_wgt),
             color = "red", size = 3) +
  geom_segment(aes(xend = hgt, yend = .fitted),
               arrow = arrow(length = unit(0.1, "cm")),
               size = 0.5, color = "darkgray")

# mod <- dat %>%
#   lm(wgt ~ hgt, data = .) %>%
#   augment(dat)
#
# ggplot(data = mod, aes(x = hgt, y = wgt)) +
#   geom_smooth(method = "lm", se = 0, formula = y ~ x,
#               color = "dodgerblue") +
#   geom_segment(aes(xend = hgt, yend = .fitted),
#                arrow = arrow(length = unit(0.1, "cm")),
#                size = 0.5, color = "darkgray") +
#   geom_point(color = "dodgerblue")
