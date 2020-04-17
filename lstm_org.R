library(tidyverse)
library(keras)
library(tensorflow)
library(tidyquant)
library(plotly)
library(forecast)
library(lubridate)

c1 <- read_csv("org_ch.csv")
c2 <- read.csv("org_dh.csv")
c3 <- read_csv("org_ko.csv")
c4 <- read_csv("org_hy.csv")
c5 <- read_csv("org_mu.csv")

c2 <- c2 %>% 
  select(dates,AQI)

c2_ts <- ts(c2[,2], start = c(2016,1), frequency = 8700)

plot.ts(c2_ts)
head(c2_ts)
attributes(c2_ts)

c2_ts <- log(c2_ts)
plot(c2_ts)

decomp <- decompose(c2_ts)

plot(decomp)

ggAcf(c2_ts) +
  ggtitle("Sample ACF for white noise")

autoplot(c2_ts)

fc <- naive(c2_ts)
autoplot(c2_ts, series = "Data") + xlab("Year") +
  autolayer(fitted(fc), series = "Fitted") +
  ggtitle("Oil production in Saudi Arabia")

autoplot(residuals(fc))

checkresiduals(fc)

training <- window(c2_ts, end = 2019)
test <- window(c2_ts, start = 2019)
fc <- naive(training, h = 10)
autoplot(fc) + autolayer(test, series = "Test data")


e <- tsCV (c2_ts, forecastfunction = naive, h = 1)
mean(e^2 , na.rm = TRUE)
