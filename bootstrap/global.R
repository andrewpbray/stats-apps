flip_coin <- function(n_flips, p_heads = 0.5) {
  probs <- c(p_heads, 1 - p_heads)
  flips <- sample(c("H", "T"), size = n_flips, replace = TRUE, prob = probs)
}

count_heads <- function(flips) {
  sum(flips == "H")
}

prop_heads <- function(flips) {
  mean(flips == "H")
}

show_flips <- function(flips) {
  data_frame(
    flip_num = seq_along(flips),
    flip = flips
  )
}

set.seed(234)
x <- flip_coin(10, p_heads = 0.65)
count_heads(x)
prop_heads(x)
show_flips(x)
