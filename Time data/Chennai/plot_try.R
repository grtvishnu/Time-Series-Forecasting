library(ggplot2)
library(lubridate)
library(scatterplot3d)
insat

c1 <- c1[,2:8]
View(c1)

theme_set(theme_bw()) # Change the theme to my preference
ggplot(aes(x = Day, y = AQI), data = c1) + geom_point()



scatterplot3d::scatterplot3d(c1[, c(3,4,6)])


s3d <- scatterplot3d(c1[, c(3,4,6)], pch = "", grid=FALSE, box=FALSE)

addgrids3d(c1[, c(3,4,6)], grid = c("xy", "xz", "yz"))

s3d$points3d(c1[, 1:3], pch = 16)
