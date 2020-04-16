library(tidyverse)
library(keras)
library(tensorflow)
library(recommenderlab)

c1 <- read_csv("org_ch.csv")
c2 <- read_csv("org_dh.csv")
c3 <- read_csv("org_ko.csv")
c4 <- read_csv("org_hy.csv")
c5 <- read_csv("org_mu.csv")



normalize(x, method = "Z-score")



c2$AQI <- (c2$AQI - mean(c2$AQI)) / sd(c2$AQI)

x <- c2$AQI
