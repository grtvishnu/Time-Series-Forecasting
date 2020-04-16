library(tidyverse)
library(keras)
library(tensorflow)

c1 <- read_csv("org_ch.csv")
c2 <- read_csv("org_dh.csv")
c3 <- read_csv("org_ko.csv")
c4 <- read_csv("org_hy.csv")
c5 <- read_csv("org_mu.csv")


set.seed(17)
ind <- sample(2, nrow(c2), replace = TRUE, prob = c(0.7, 0.3))
c2.training <- c2[ind == 1, 1:5]
c2.test <- c2[ind == 2, 1:5]
c2.trainingtarget <- c2[ind == 1, -seq(5)]
c2.testtarget <- c2[ind == 2, -(1:5)]

model <- keras_model_sequential()

model %>%
  layer_dense(units = ncol(c2.trainingtarget), activation = 'relu',
              input_shape = ncol(c2.training))
summary(model)

model$inputs
model$outputs
