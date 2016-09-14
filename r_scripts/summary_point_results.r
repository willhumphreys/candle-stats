library('ggthemes')
library('ggplot2')
library(MASS)
#8 -- 22   1111111101010101010101 15 -> 7

data <- read.table('results/summary_high_scores.csv', header=T,sep=",")

data$start_date.time=as.Date(as.POSIXct(data$start_date, tz = "UTC", format="%Y-%m-%dT%H:%M:%S"))

data$winners.above.50 <- data$winners > 2

data <- data[complete.cases(data), ]

data$moving_average_buy_minimum <- paste(data$moving_average_count, data$minimum_profit, sep="_")

start_date <- as.Date("2014-08-02")
end_date <- as.Date("2016-08-02")

data <- data[data$start_date.time == start_date, ]
#data <- data[data$end_date.time == end_date, ]

data <- data[ which(
    data$winners > 10
    & data$losers > 10
    & data$running_moving_average < 20
    # & data$running_moving_average <= 36
    & data$buy_minimum > 4
    # & data$buy_minimum < 14
    )
    ,]

mean <- mean(data$winning_percentage)

ave <- data.frame( x = c(-Inf, Inf), y = mean, ave = factor(mean) )

ggplot(data=data, aes(x=minimum_profit, y=winning_percentage, group=1)) +
    geom_line() +
    geom_point(aes(colour = factor(data$winners.above.50))) +
    geom_line(aes( x, y, linetype = ave ), ave) +
    facet_grid(. ~ moving_average_count) +
    scale_x_continuous(limits=c(6, 10)) +

    ggtitle('summaryPositive2014r22bm5.png')
    ggsave(file='cumsum_profits/summaryPositive2014r22bm5.png')

