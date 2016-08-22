data <- read.table('results/summary.csv', header=T,sep=",")

data$start_date.time=as.Date(as.POSIXct(data$start_date, tz = "UTC", format="%Y-%m-%dT%H:%M:%S"))

data<-subset(data, date_period==2)
data<-subset(data, buy_minimum < 8)
data<-subset(data, buy_minimum > -8)

data <- data[complete.cases(data), ]

ggplot(data=data, aes(x=start_date, y=win_lose_percentage, colour=factor(buy_minimum), group=factor(buy_minimum))) +
    geom_line()  + theme(axis.text.x = element_text(angle = 90, hjust = 1)) + geom_point()
