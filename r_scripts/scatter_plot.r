library('ggthemes')
library('ggplot2')

file.in <- 'summary_high_scores.csv'
dir.out <- 'could_of_been_better_results'

#colours
red <- "#FF9999"

sprintf("loading data from : %s", file.in)
sprintf("outputing plots to : %s", dir.out)
data <- read.table(file.in, header=T,sep=",")
print('data loaded')
get.year <- function(date) {
    return ((strsplit(date, "-")[[1]])[1])
}

append.year.filename <- function(filename, start_year, end_year) {
    complete.file.name <- (paste(dir.out, filename, start_year, "-", end_year, ".png", sep=""))
    sprintf("saving file: %s", complete.file.name)
    return (complete.file.name)
}

generate.plots.by.date <- function(start_date, end_date, data) {

  #start_date <- '2015-08-02T00:00:00+00:00'
  #end_date <- '2017-08-02T00:00:00+00:00'

  filtered_data <- data[data$start_date == start_date,]
  filtered_data <- filtered_data[filtered_data$end_date == end_date,]

  average_per_cut_off <- aggregate(filtered_data[, c("winning_percentage")], list(filtered_data$cut_off_percentage), mean)
  average_per_cut_off_minimum <- aggregate(filtered_data[, c("winning_percentage","minimum_profit")],
    list(filtered_data$cut_off_percentage, filtered_data$minimum_profit), mean)

  start_year = get.year(start_date)
  end_year = get.year(end_date)

  ggplot(average_per_cut_off_minimum, aes(x=Group.1, y=winning_percentage)) +
  geom_bar(stat="identity", colour=red) +
  theme(axis.text.x = element_text(angle = 90, hjust = 1))
  ggsave(file=append.year.filename("/average_cut_off_minimum-", start_year, end_year))

  ggplot(average_per_cut_off_minimum, aes(x=Group.1, y=winning_percentage)) +
  geom_bar(stat="identity", colour="#FF9999") +
  scale_y_continuous(breaks=seq(0,80,3)) +
  theme(axis.text.x = element_text(angle = 90, hjust = 1)) +
  facet_grid(. ~ Group.2)
  ggsave(file=append.year.filename("/average_cut_off_minimum_facet-", start_year,  end_year))

  generate.average.line.plot <- function(dat, out.file) {

    ggplot(data=dat, aes(x=Group.1, y=x, group=1)) +
      geom_line() +
      scale_y_continuous(breaks=seq(50,80,0.3)) +
      scale_x_continuous(breaks=seq(-100,100,5))
    ggsave(file=out.file)

  }

  generate.scatter.plot <- function(dat, out.file) {

    ggplot(data=dat, aes(x=cut_off_percentage, y=winning_percentage)) +
      geom_point(shape=1)  +    # Use hollow circles
      stat_summary(aes(y = winning_percentage,group=1), fun.y=mean, colour="red", geom="line",group=1) +
      scale_y_continuous(breaks=seq(0,100,10))
    ggsave(file=out.file)
  }

  generate.average.line.plot(average_per_cut_off, paste(dir.out, "/profit_by_cutoff-", start_year, "-", end_year, ".png", sep=""))
  generate.scatter.plot(filtered_data, append.year.filename("/scatter-", start_year, end_year))

  generate.minimum.plots <- function(minimum_value, data) {
      filtered.data <- data[ which(data$minimum_profit==minimum_value ),]

      average_per_cut_off <- aggregate(filtered.data[, c("winning_percentage")], list(filtered.data$cut_off_percentage), mean)

      generate.average.line.plot(average_per_cut_off, paste(dir.out, "/profit_by_cutoff_", minimum_value, "-", start_year, "-", end_year, ".png", sep=""))
      generate.scatter.plot(filtered.data, paste(dir.out, "/scatter_", minimum_value, "-", start_year, "-", end_year, ".png", sep=""))

  }

  minimum_fade_start <- 2
  minimum_fade_end <- 36

  sapply(seq(minimum_fade_start, minimum_fade_end, by=2), function(x) generate.minimum.plots(x, filtered_data))

}

unique_start_and_end_dates <-  unique(data[c("start_date", "end_date")])

apply(unique_start_and_end_dates, 1, function(x) generate.plots.by.date(x[1], x[2], data))