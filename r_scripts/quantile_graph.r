library(SparseM)
library(ggplot2)
library(quantreg)
library(plyr)
library(ggthemes)

data <- read.table('r_out/quantiles.csv', header=T,sep=",")

ggplot(data, aes(x = symbol, y = X20))

higher_high_close_inside <- data[grep("higher_high_close_inside", data$symbol), ]

ggplot(higher_high_close_inside, aes(x = symbol, y = X20))