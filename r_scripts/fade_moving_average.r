library(ggplot2)

generate.plot <- function(file.in) {

  data <- read.table(paste('results/',file.in, sep = ""), header=T,sep=",")

  data$date=as.Date(as.POSIXct(data$date, tz = "UTC", format="%Y/%m/%d"))

  data.highs <- data[ which(data$direction=='fail at highs'),]
  data.lows <- data[ which(data$direction=='fail at lows'),]

  generate.plot <- function(data, high_or_low) {

    ggplot(data=data, aes(x=date, y=moving_average)) +
    geom_line() +
    geom_point() +
    scale_y_continuous(breaks=seq(-14,14,1)) +
    ggtitle(paste(file.in, '-', high_or_low, sep = ""))
    ggsave(file=paste('moving_average_fade_plots/',file.in, high_or_low,".png", sep = ""))
  }

  generate.plot(data.highs, 'highs')
  generate.plot(data.lows, 'lows')
}

in_files <- list.files('results')

filtered_in_files <-in_files[grepl("^r.*", in_files)]

sapply(filtered_in_files, function(x) generate.plot(x))