library(tidyverse)
library(keras)
library(tensorflow)

c1 <- read_csv("org_ch.csv")
c2 <- read.csv("org_dh.csv")
c3 <- read_csv("org_ko.csv")
c4 <- read_csv("org_hy.csv")
c5 <- read_csv("org_mu.csv")

c2_op <- c2
c2_op$AQI<- scale(c2_op$AQI, center = T, scale = T)

p1 <- c1 %>%
  ggplot(aes(dates, AQI)) +
  geom_point(color = palette_light()[[1]], alpha = 0.5) +
  theme_tq() +
  labs(
    title = "From 2016 to 2020 (Full Data Set)"
  )