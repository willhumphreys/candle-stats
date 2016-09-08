library('ggthemes')
library('ggplot2')

dir.in <- 'could_of_been_better_results'
file.in <- 'summary_high_scores.csv'
dir.out <- 'could_of_been_better_results'

#colours
red <- "#FF9999"

sprintf("loading data from : %s", file.in)
sprintf("outputing plots to : %s", dir.out)
data <- read.table(paste(dir.in, "/", file.in, sep=""), header=T,sep=",")
print('data loaded')
get.year <- function(date, split_character) {
    return ((strsplit(date, split_character)[[1]])[1])
}

append.year.filename <- function(filename, start_year, end_year) {
    complete.file.name <- (paste(dir.out, filename, get.year(start_year,"-"), "-", get.year(end_year,"-"), ".png", sep=""))

    print(complete.file.name)
    return (complete.file.name)
}

generate.plots.by.date <- function(start_date, end_date, data) {

  #start_date <- '2015-08-02T00:00:00+00:00'
  #end_date <- '2017-08-02T00:00:00+00:00'

  filtered_data <- data[data$start_date == start_date,]
  filtered_data <- filtered_data[filtered_data$end_date == end_date,]

  #x cut_off_percentage y winning_percentage
  average_per_cut_off <- setNames(aggregate(filtered_data[, c("winning_percentage")], list(filtered_data$cut_off_percentage), mean), c("cut_off_percentage", "winning_percentage"))
  average_per_cut_off_minimum <- setNames(aggregate(filtered_data[, c("winning_percentage","minimum_profit")],
    list(filtered_data$cut_off_percentage, filtered_data$minimum_profit), mean), c("cut_off_percentage", "minimum_profit_2", "winning_percentage", "minimum_profit" ))

  start_year = get.year(start_date,"_")
  end_year = get.year(end_date,"_")

  ggplot(average_per_cut_off, aes(x=cut_off_percentage, y=winning_percentage)) +
  geom_bar(stat="identity", colour=red) +
  #coord_cartesian(ylim=c(40, 110)) +
  theme(axis.text.x = element_text(angle = 90, hjust = 1)) +
  geom_vline(0)
  ggsave(file=append.year.filename("/average_cut_off_minimum_", start_year, end_year))

  ggplot(average_per_cut_off_minimum, aes(x=cut_off_percentage, y=winning_percentage)) +
  geom_bar(stat="identity", colour="#FF9999") +
  #coord_cartesian(ylim=c(40, 110)) +
  theme(axis.text.x = element_text(angle = 90, hjust = 1, size = 14), axis.text.y = element_text(size = 20)) +
  facet_grid(. ~ minimum_profit) +
  geom_vline(0) +
  theme(axis.title=element_text(size=20))
  ggsave(file=append.year.filename("/average_cut_off_minimum_facet_", start_year,  end_year), width = 21, height = 15)

  generate.average.line.plot <- function(dat, out.file) {

    ggplot(data=dat, aes(x=cut_off_percentage, y=winning_percentage, group=1)) +
      geom_line() +
      #scale_y_continuous(breaks=seq(50,80,0.3)) +
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

  generate.average.line.plot(average_per_cut_off, append.year.filename("/profit_by_cutoff_", start_year, end_year))
  generate.scatter.plot(filtered_data, append.year.filename("/scatter_", start_year, end_year))

  generate.minimum.plots <- function(minimum_value, data) {
      filtered.data <- data[ which(data$minimum_profit==minimum_value ),]

      average_per_cut_off <- setNames(aggregate(filtered.data[, c("winning_percentage")], list(filtered.data$cut_off_percentage), mean), c("cut_off_percentage","winning_percentage"))

      generate.average.line.plot(average_per_cut_off, append.year.filename(paste("/profit_by_cutoff_", minimum_value, "_", sep=""), start_year, end_year))
      generate.scatter.plot(filtered.data, append.year.filename(paste("/scatter_", minimum_value, "_",sep=""), start_year, end_year))

  }

  minimum_fade_start <- 2
  minimum_fade_end <- 36

  sapply(seq(minimum_fade_start, minimum_fade_end, by=2), function(x) generate.minimum.plots(x, filtered_data))

}

unique_start_and_end_dates <-  unique(data[c("start_date", "end_date")])

apply(unique_start_and_end_dates, 1, function(x) generate.plots.by.date(x[1], x[2], data))