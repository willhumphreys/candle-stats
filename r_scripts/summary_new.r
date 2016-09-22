library('ggthemes')
library('ggplot2')

data <- read.table('results/summary_high_scores-2-100-bands.csv', header=T,sep=",")
data$start_date.time=as.Date(as.POSIXct(data$start_date, tz = "UTC", format="%Y-%m-%dT%H:%M:%S"))
data <- data[complete.cases(data), ]
by_cut_off_min <- aggregate(cbind(winners.size, losers.size)~cut_off_percentage+minimum_profit, data=data, sum, na.rm=TRUE)
by_cut_off_min$ave <- (by_cut_off_min$winners.size / (by_cut_off_min$winners.size + by_cut_off_min$losers.size)) * 100

ggplot(data=by_cut_off_min, aes(x=cut_off_percentage, y=ave)) +
    facet_grid(minimum_profit ~ .) +
    geom_hline(aes(yintercept=30), colour="#990000", linetype="dashed") +
    geom_hline(aes(yintercept=60), colour="#990000", linetype="dashed") +
    geom_bar(stat="identity")
ggsave(file='plots/summary_high_scores-2-100-bands.csv.png', width = 21, height = 15)