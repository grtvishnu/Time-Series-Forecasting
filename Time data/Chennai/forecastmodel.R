library(ggplot2)
library(prophet)

qplot(dates,
      AQI,
      data = c1)


ds <- c1$dates
y <- log(c1$AQI)
df <- data.frame(ds, y)


qplot(ds,
      y,
      data = df)

m <- prophet(df)
m

future <- make_future_dataframe(m,
                                periods = 15)

tail(future)

forecast <- predict(m,
                    future)

tail(forecast[c('ds', 'yhat')])
exp(4.058228)

# plot(m, forecast)

prophet_plot_components(m, forecast)
