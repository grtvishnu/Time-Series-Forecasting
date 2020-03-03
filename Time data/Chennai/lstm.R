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
install.packages("yardstick")
View(c1)

Date <- c1$Date_1
Date <- format(as.POSIXct(Date, format= '%m-%d-%Y'), format ='%Y-%d-%m' )
Date
Date <-as.Date(Date, "%m/%d/%Y %H:%M:%S")
class(Date)
c1$Date <- mdy(c1$cdate)
c1 <- c1 %>%
  tk_tbl() %>%
  mutate(cdate = as_date(cdate)) %>%
  as_tbl_time(cdate = cdate)

class(Date)
sun_spots

p1 <- c1 %>%
  ggplot(aes(Date_1, AQI)) +
  geom_point(color = palette_light()[[1]], alpha = 0.5) +
  theme_tq() +
  labs(
    title = "From 2016 to 2016 (Full Data Set)"
  )

p2 <- c1 %>%
  filter_time("start" ~ "2016") %>%
  ggplot(aes(Date_1, AQI)) +
  geom_line(color = palette_light()[[1]], alpha = 0.5) +
  geom_point(color = palette_light()[[1]]) +
  geom_smooth(method = "loess", span = 0.2, se = FALSE) +
  theme_tq() +
  labs(
    title = "1749 to 1800 (Zoomed In To Show Cycle)",
    caption = "datasets::sunspot.month"
  )


 
c1 <- cbind(c1, Date)
c1


write.csv(c1, file = "newdatec12.csv")
  x