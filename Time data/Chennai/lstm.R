library(tidyverse)
library(glue)
library(forcats)
library(timetk)
library(tidyquant)
library(tibbletime)
library(cowplot)
library(recipes)
library(rsample)
library(yardstick) 
library(keras)
library(ggplot2)
View(c1)

p1 <- c1 %>%
  ggplot(aes(dates, AQI)) +
  geom_point(color = palette_light()[[1]], alpha = 0.5) +
  theme_tq() +
  labs(
    title = "From 2016 to 2020 (Full Data Set)"
  )

p2 <- c1 %>%
  ggplot(aes(dates, AQI)) +
  geom_line(color = palette_light()[[1]], alpha = 0.5) +
  geom_point(color = palette_light()[[1]]) +
  geom_smooth(method = "loess", span = 0.2, se = FALSE) +
  theme_tq() +
  labs(
    title = "1asdsad",
    caption = "dasdasd"
  )
p_title <- ggdraw() + 
  draw_label("AQI", size = 18, fontface = "bold", colour = palette_light()[[1]])

plot_grid(p_title, p1, p2, ncol = 1, rel_heights = c(0.1, 1, 1))


tidy_acf <- function(data, value, lags = 0:20) {
  
  value_expr <- enquo(value)
  
  acf_values <- data %>%
    pull(value) %>%
    acf(lag.max = tail(lags, 1), plot = FALSE) %>%
    .$acf %>%
    .[,,1]
  
  ret <- tibble(acf = acf_values) %>%
    rowid_to_column(var = "lag") %>%
    mutate(lag = lag - 1) %>%
    filter(lag %in% lags)
  
  return(ret)
}