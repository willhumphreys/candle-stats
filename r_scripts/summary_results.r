library(ggthemes)
library(ggplot)

data <- read.table('could_of_been_better/results/summary-high-scores.csv', header=T,sep=",")

data$start_date.time=as.Date(as.POSIXct(data$start_date, tz = "UTC", format="%Y-%m-%dT%H:%M:%S"))


data <- data[complete.cases(data), ]

ggplot(data=data, aes(x=start_date, y=winning_percentage, colour=factor(minimum_profit), group=factor(minimum_profit))) +
    geom_line()  + theme(axis.text.x = element_text(angle = 90, hjust = 1)) + geom_point()
