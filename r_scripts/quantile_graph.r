library(SparseM)
library(ggplot2)
library(quantreg)
library(plyr)
library(ggthemes)

timeframes <- c("1440", "10080")
names <- c("higher_high_close_inside", "higher_high_close_above", "lower_low_close_below", "lower_low_close_inside")

name_timeframe_combinations <- expand.grid(timeframes,names)

combinations <- paste(name_timeframe_combinations$Var1, name_timeframe_combinations$Var2, sep="_")

generate.quantile.plot <- function(name, data) {
    higher_high_close_inside <- data[grep(name, data$symbol), ]
    higher_high_close_inside$symbol = strtrim(higher_high_close_inside$symbol, 6)

    ggplot(data=higher_high_close_inside, aes(x=symbol, y=P20)) +
        geom_bar(colour="black", fill="#DD8888", width=.8, stat="identity") +
        theme_solarized() +
        theme(axis.text.x = element_text(angle = 90, hjust = 1))

    ggsave(file=paste("plots/", name, ".png", sep = ""))
}

data <- read.table('r_out/quantiles.csv', header=T,sep=",")

sapply(combinations, function(x) generate.quantile.plot(x, data))