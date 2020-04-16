library(tidyverse)
library(keras)
library(tensorflow)
library(tidyquant)
library(plotly)

c1 <- read_csv("org_ch.csv")
c2 <- read.csv("org_dh.csv")
c3 <- read_csv("org_ko.csv")
c4 <- read_csv("org_hy.csv")
c5 <- read_csv("org_mu.csv")

c2 <- c2 %>% 
  select(dates,AQI)
str(c2)
View(c2)
c2$AQI<- scale(c2$AQI, center = T, scale = T)

p1 <- c2 %>%
  ggplot(aes(dates, AQI)) +
  geom_point(color = palette_light()[[1]], alpha = 0.5) +
  theme_tq() +
  labs(
    title = "From 2016 to 2020 (Full Data Set)"
  )

lookback = 1440
steps = 6
delay = 144

sequence_generator <- function(start) {
  value <- start - 1
  function() {
    value <<- value + 1
    value
  }
}

gen <- sequence_generator(10)
gen()

c2 <- data.matrix(c2[,-1])

set.seed(1234)
ind <- sample(2, nrow(c2), replace = T, prob = c(.8, .2))
training <- c2[ind == 1, ]
test <- c2[ind == 2, ]

generator <- function(data, lookback, delay, min_index, max_index,
                      shuffle = FALSE, batch_size = 128, step = 6) {
  if (is.null(max_index))
    max_index <- nrow(data) - delay - 1
  i <- min_index + lookback
  function() {
    if (shuffle) {
      rows <- sample(c((min_index+lookback):max_index), size = batch_size)
    } else {
      if (i + batch_size >= max_index)
        i <<- min_index + lookback
      rows <- c(i:min(i+batch_size-1, max_index))
      i <<- i + length(rows)
    }
    
    samples <- array(0, dim = c(length(rows),
                                lookback / step,
                                dim(data)[[-1]]))
    targets <- array(0, dim = c(length(rows)))
    
    for (j in 1:length(rows)) {
      indices <- seq(rows[[j]] - lookback, rows[[j]]-1,
                     length.out = dim(samples)[[2]])
      samples[j,,] <- data[indices,]
      targets[[j]] <- data[rows[[j]] + delay,2]
    }           
    list(samples, targets)
  }
}

lookback <- 1440
step <- 6
delay <- 144
batch_size <- 128


train_gen <- generator(
  data,
  lookback = lookback,
  delay = delay,
  min_index = 1,
  max_index = 200000,
  shuffle = TRUE,
  step = step, 
  batch_size = batch_size
)

val_gen = generator(
  data,
  lookback = lookback,
  delay = delay,
  min_index = 200001,
  max_index = 300000,
  step = step,
  batch_size = batch_size
)

test_gen <- generator(
  data,
  lookback = lookback,
  delay = delay,
  min_index = 300001,
  max_index = NULL,
  step = step,
  batch_size = batch_size
)


val_steps <- (25000 - 10000 - lookback) / batch_size
test_steps <- (nrow(c2) - 25000 - lookback) / batch_size

model <- keras_model_sequential() %>% 
  layer_flatten(input_shape = c(lookback / step, dim(c2)[-1])) %>% 
  layer_dense(units = 32, activation = "relu") %>% 
  layer_dense(units = 1)

model %>% compile(
  optimizer = optimizer_rmsprop(),
  loss = "mae"
)

history <- model %>% fit_generator(
  train_gen,
  steps_per_epoch = 500,
  epochs = 20,
  validation_data = val_gen,
  validation_steps = val_steps
)
