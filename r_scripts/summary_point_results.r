library('ggthemes')
library('ggplot2')

#8 -- 22   1111111101010101010101 15 -> 7

data <- read.table('results/summary.csv', header=T,sep=",")

data$start_date.time=as.Date(as.POSIXct(data$start_date, tz = "UTC", format="%Y-%m-%dT%H:%M:%S"))

data$winners.above.50 <- data$winners > 50

data <- data[complete.cases(data), ]

data$moving_average_buy_minimum <- paste(data$running_moving_average, data$buy_minimum, sep="_")

data <- data[ which(
    data$winners > 10
    & data$losers > 10
    # & data$running_moving_average >= 20
    # & data$running_moving_average <= 36
    # & data$buy_minimum > 5
    # & data$buy_minimum < 14
    )
    ,]

ggplot(data=data, aes(x=buy_minimum, y=win_lose_percentage, group=1)) +
    geom_line() +
    geom_point(aes(colour = factor(data$winners.above.50))) +
    facet_grid(. ~ running_moving_average) +

    ggtitle('summaryNegative.png')
    ggsave(file='cumsum_profits/summaryNegative.png')
