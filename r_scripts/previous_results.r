data <- read.table('results/summary.csv', header=T,sep=",")

data$start_date.time=as.Date(as.POSIXct(data$start_date, tz = "UTC", format="%Y-%m-%dT%H:%M:%S"))


ggplot(data=data, aes(x=start_date, y=win_lose_percentage, colour=date_period, shape = buy_minimum, group=interaction(buy_minimum, date_period))) +
    geom_line()  + theme(axis.text.x = element_text(angle = 90, hjust = 1)) + scale_shape_identity()
