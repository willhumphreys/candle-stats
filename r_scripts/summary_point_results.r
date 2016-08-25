library('ggthemes')
library('ggplot2')

data <- read.table('results/summary.csv', header=T,sep=",")

data$start_date.time=as.Date(as.POSIXct(data$start_date, tz = "UTC", format="%Y-%m-%dT%H:%M:%S"))


data <- data[complete.cases(data), ]

data$moving_average_buy_minimum <- paste(data$running_moving_average, data$buy_minimum, sep="_")

data <- data[ which(data$winners > 10
& data$losers > 10), ]

ggplot(data=data, aes(x=buy_minimum, y=win_lose_percentage, group=1)) +
    geom_line() +
    facet_grid(. ~ running_moving_average) +
    ggtitle(file.in)
    ggsave(file='cumsum_profits/summaryNegative.png')
