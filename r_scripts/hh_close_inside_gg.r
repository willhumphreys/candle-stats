library(ggplot2)
library(quantreg)
library(plyr)
library(ggthemes)
data <- read.table("out/higher_high_close_in_range.csv", header=T,sep=",")
data$fixed.date.time=as.POSIXct(data$date.time, tz = "UTC")
data$date.time <- data$fixed.date.time
data$fixed.date.time <- NULL
fit.50 <- quantreg::rq(pips ~ splines::bs(date.time, df=15), tau=0.50, data=data)
fit.80 <- quantreg::rq(pips ~ splines::bs(date.time, df=15), tau=0.80, data=data)
fit.20 <- quantreg::rq(pips ~ splines::bs(date.time, df=15), tau=0.20, data=data)
data$pc.50 = predict(fit.50)
data$pc.20 = predict(fit.20)
data$pc.80 = predict(fit.80)
higher_high_close_in_range_plot <- ggplot(data, aes(x = date.time)) +
geom_point(aes(y = pips)) +
geom_line(aes(y = pc.50, colour = 'Median')) +
geom_line(aes(y = pc.80, colour = '80')) +
geom_line(aes(y = pc.20, colour = '20')) +
geom_hline(aes(yintercept = quantile(data$pips, .50), colour = 'Median')) +
geom_hline(aes(yintercept = quantile(data$pips, .80), colour = '80')) +
geom_hline(aes(yintercept = quantile(data$pips, .20), colour = '20')) +
labs(x="Date",y="Pips") +
theme_solarized() +
ggtitle("Break size when we close back inside")
ggsave(file="out/higher_high_close_in_range.png")