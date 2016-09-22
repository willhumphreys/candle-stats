library(ggthemes)
library(ggplot)

data <- read.table('could_of_been_better_results/summary_high_scores.csv', header=T,sep=",")
data$start_date.time=as.Date(as.POSIXct(data$start_date, tz = "UTC", format="%Y-%m-%dT%H:%M:%S"))
data <- data[complete.cases(data), ]
#data <- data[data$minimum_profit == 38,]

# by_cut_off <- aggregate(data[,c("winners.size", "losers.size")], by=list(Category=data$cut_off_percentage), FUN=sum)
# by_cut_off$ave <- (by_cut_off$winners.size / (by_cut_off$winners.size + by_cut_off$losers.size)) * 100
#
# ggplot(data=by_cut_off, aes(x=Category, y=ave)) +
#     facet_grid(. ~ minimum_profit) +
#     geom_bar(stat="identity")


by_cut_off_min <- aggregate(cbind(winners.size, losers.size)~cut_off_percentage+minimum_profit, data=data, sum, na.rm=TRUE)
by_cut_off_min$ave <- (by_cut_off_min$winners.size / (by_cut_off_min$winners.size + by_cut_off_min$losers.size)) * 100

ggplot(data=by_cut_off_min, aes(x=cut_off_percentage, y=ave)) +
    facet_grid(minimum_profit ~ .) +
    geom_bar(stat="identity")
ggsave(file='plots/winnerPercentageAgainstCutOffPercentage.png', width = 21, height = 15)