library(SparseM)
library(ggplot2)
library(quantreg)
library(plyr)
library(ggthemes)

timeframes <- c("1440", "10080")
names <- c("higher_high_close_inside", "higher_high_close_above", "lower_low_close_below", "lower_low_close_inside")

quantiles <- c("P20", "P50", "P80")

name_timeframe_combinations <- expand.grid(timeframes,names)

combinations <- paste(name_timeframe_combinations$Var1, name_timeframe_combinations$Var2, sep="_")

generate.quantile.plot <- function(combination, data) {
    fixed_data <- data[grep(combination, data$symbol), ]
    fixed_data$symbol = strtrim(fixed_data$symbol, 6)

    sapply(quantiles, function(quantile) plot.quantiles(fixed_data, combination, quantile))
}

plot.quantiles <- function(data, name, quantile) {
    ggplot(data=data, aes_string(x="symbol", y=quantile)) +
        geom_bar(colour="black", fill="#DD8888", width=.8, stat="identity") +
        theme_solarized() +
        theme(axis.text.x = element_text(angle = 90, hjust = 1))

    graph_name <- paste("plots/", name, quantile, ".png", sep = "")
    cat(graph_name)
    ggsave(file= graph_name)
}

data <- read.table('r_out/quantiles.csv', header=T,sep=",")

sapply(combinations, function(combination) generate.quantile.plot(combination, data))