library(ggplot2)

generate.plot <- function(file.in) {

  data <- read.table(paste('fade_ruby_out/',file.in, sep = ""), header=T,sep=",")

  data$date=as.Date(as.POSIXct(data$date, tz = "UTC", format="%Y/%m/%d"))

  generate.plot <- function(data) {

    ggplot(data=data, aes(x=date, y=moving_average, group=direction)) +
    geom_line(aes(color=direction)) +
    ggtitle(file.in)
    ggsave(file=paste('moving_average_fade_plots/',file.in, ".png", sep = ""))
  }

  generate.plot(data)
}

in_files <- list.files('fade_ruby_out')

filtered_in_files <-in_files[grepl("^r.*", in_files)]

sapply(filtered_in_files, function(x) generate.plot(x))