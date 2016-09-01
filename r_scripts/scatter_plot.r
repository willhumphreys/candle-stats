library('ggthemes')
library('ggplot2')

data <- read.table('could_of_been_better_results/summary_high_scores.csv', header=T,sep=",")

average_per_cut_off <- aggregate(data[, 7], list(data$cut_off_percentage), mean)

generate.average.line.plot <- function(dat, out.file) {

  ggplot(data=dat, aes(x=Group.1, y=x, group=1)) +
    geom_line() +
    scale_y_continuous(breaks=seq(50,55,0.1))
  ggsave(file=out.file)

}

generate.scatter.plot <- function(dat, out.file) {

  ggplot(dat, aes(x=cut_off_percentage, y=winning_percentage)) +
    geom_point(shape=1)  +    # Use hollow circles
    stat_summary(aes(y = winning_percentage,group=1), fun.y=mean, colour="red", geom="line",group=1) +
    scale_y_continuous(breaks=seq(0,100,10))
  ggsave(file=out.file)
}

generate.average.line.plot(average_per_cut_off, "could_of_been_better_results/profit_by_cutoff.png")
generate.scatter.plot(data, "could_of_been_better_results/scatter.png")

no_japan <- data[!grepl("usdjpy", data$data_set),]
no_japan <- data[!grepl("eurjpy", data$data_set),]

average_per_cut_off_no_japan <- aggregate(no_japan[, 7], list(no_japan$cut_off_percentage), mean)

generate.scatter.plot(no_japan, "could_of_been_better_results/scatter.png")
generate.average.line.plot(average_per_cut_off_no_japan, "could_of_been_better_results/profit_by_cutoff.png")

