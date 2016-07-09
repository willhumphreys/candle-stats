data <- read.table("out/higher_high_close_above.csv", header=T,sep=",")
attach(data)
plot(higher_high_close_above)
abline(h=c(quantile(data$higher_high_close_above, 0.5)))
abline(h=c(quantile(data$higher_high_close_above, 0.8)))