library('ggthemes')
library('ggplot2')

data <- read.table('could_of_been_better_results/summary_high_scores.csv', header=T,sep=",")


ggplot(data, aes(x=cut_off_percentage, y=winning_percentage)) +
    geom_point(shape=1)  +    # Use hollow circles
    stat_summary(aes(y = winning_percentage,group=1), fun.y=mean, colour="red", geom="line",group=1) +
    scale_y_continuous(breaks=seq(0,100,10)) +
    facet_grid(. ~ minimum_profit)