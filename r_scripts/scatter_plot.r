library('ggthemes')
library('ggplot2')

data <- read.table('could_of_been_better_results/summary_high_scores.csv', header=T,sep=",")

average_per_cut_off <- aggregate(data[, 7], list(data$cut_off_percentage), mean)
average_per_cut_off_minimum <- aggregate(data[, 7, 2], list(data$cut_off_percentage, data$minimum_profit), mean)


ggplot(average_per_cut_off_minimum, aes(x=Group.1, y=x)) +
geom_bar(stat="identity", colour="#FF9999") +
theme(axis.text.x = element_text(angle = 90, hjust = 1))
ggsave(file="could_of_been_better_results/average_cut_off_minimum.png")

ggplot(average_per_cut_off_minimum, aes(x=Group.1, y=x)) +
geom_bar(stat="identity", colour="#FF9999") +
scale_y_continuous(breaks=seq(0,80,3)) +
theme(axis.text.x = element_text(angle = 90, hjust = 1)) +
facet_grid(. ~ Group.2)
ggsave(file="could_of_been_better_results/average_cut_off_minimum_facet.png")

generate.average.line.plot <- function(dat, out.file) {

  ggplot(data=dat, aes(x=Group.1, y=x, group=1)) +
    geom_line() +
    scale_y_continuous(breaks=seq(50,80,0.3)) +
    scale_x_continuous(breaks=seq(-100,100,5))
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


generate.minimum.plots <- function(minimum_value, data) {
    filtered.data <- data[ which(data$minimum_profit==minimum_value ),]

    average_per_cut_off <- aggregate(filtered.data[, 7], list(filtered.data$cut_off_percentage), mean)

    generate.average.line.plot(average_per_cut_off, paste("could_of_been_better_results/profit_by_cutoff_", minimum_value, ".png", sep=""))
    generate.scatter.plot(filtered.data, paste("could_of_been_better_results/scatter_", minimum_value, ".png", sep=""))

}


sapply(seq(2, 36, by=2), function(x) generate.minimum.plots(x, data))