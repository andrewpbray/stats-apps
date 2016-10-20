library(ggplot2)
library(dplyr)
library(openintro)
library(broom)

dat <- bdims

mod <- bdims %>%
  lm(wgt ~ hgt, data = .) %>%
  augment(bdims)

ggplot(data = mod, aes(x = hgt, y = wgt)) +
  geom_smooth(method = "lm", se = 0, formula = y ~ x,
              color = "dodgerblue") +
  geom_segment(aes(xend = hgt, yend = .fitted),
               arrow = arrow(length = unit(0.1, "cm")),
               size = 0.5, color = "darkgray") +
  geom_point(color = "dodgerblue")
