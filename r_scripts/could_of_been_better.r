library('ggthemes')
library('ggplot2')

data <- read.table('could_of_been_better_results/summary.csv', header=T,sep=",")
data <- data[complete.cases(data), ]

# ggplot(data=data, aes(x=cut_off, y=winning_percentage, group=1)) +
#     geom_line() +
#     #geom_point(aes(colour = factor(data$winners.above.50))) +
#     #geom_line(aes( x, y, linetype = ave ), ave) +
#     facet_grid(. ~ moving_average_count)
#     #scale_x_continuous(limits=c(6, 10)) +
#
#     ggtitle('summary')
#     ggsave(file='could_of_been_better_results/summary-ma.png')
#
#
# ggplot(data=data, aes(x=moving_average_count, y=winning_percentage, group=1)) +
#     geom_line() +
#     #geom_point(aes(colour = factor(data$winners.above.50))) +
#     #geom_line(aes( x, y, linetype = ave ), ave) +
#     facet_grid(. ~ cut_off)
#     #scale_x_continuous(limits=c(6, 10)) +
#
#     ggtitle('summary_cut_off')
#     ggsave(file='could_of_been_better_results/summary_cut_off-co.png')
#
#
# ave <- data.frame( x = c(-Inf, Inf), y = mean, ave = factor(mean) )
#
#     ggplot(data=data, aes(x=cut_off_percentage, y=winning_percentage)) +
#         geom_bar(stat = "summary", fun.y = "mean") +
#         facet_grid(.~better_level) +
#         stat_summary(fun.y = "mean", fun.ymin = "mean", fun.ymax= "mean", geom = "line") +
#     ggtitle('cut_off_percentage vs winning_percentage')
#     ggsave(file='could_of_been_better_results/summary_cut_off_percentage_vs_winning_percentage.png')


plot.better_level.filter <- function(data_set_b, better_level_b, data) {
 data_set <- getElement(data_set_b, "Var1")
 better_level <- getElement(better_level_b,"Var2")

 print(data_set)
 better_level <- as.numeric(trimws(better_level))
 print(better_level)

 filtered.data <- data[data$better_level == better_level, ]

 print(nrow(filtered.data))

 filtered.data <- filtered.data[filtered.data$data_set == paste(data_set, '_FadeTheBreakoutNormalDaily', sep=""),]

 print(nrow(filtered.data))

out.file <- paste('could_of_been_better_results/summary_both-', better_level, '-', data_set, '.png', sep="")

print(out.file)

 ggplot(data=filtered.data, aes(x=cut_off_percentage, y=winning_percentage)) +
        geom_bar(stat = "summary", fun.y = "mean")
        ggsave(file=out.file)
}

range <- 1:20

data_sets <- c("audusd", "eurchf" , "eurgbp", "eurusd", "gbpusd", "usdcad", "usdchf", "nzdusd", "usdjpy", "eurjpy")

combinations <- expand.grid(data_sets,range)

apply(combinations, 1, function(x) plot.better_level.filter(x[1],x[2], data))
