library(ggplot2)

generate.plot <- function(file.in) {
    file.out <- paste("consecutive_plots/",(strsplit(file.in, split='.', fixed=TRUE)[[1]])[1], ".png", sep = "")

    data <- read.table(paste("consecutive_out/",file.in, sep=""), header=T,sep=",")

    #data <- data[-2,]
    data <- data[complete.cases(data),]

    data$date.time=as.Date(as.POSIXct(data$date, tz = "UTC", format="%Y-%m-%dT%H:%M:%S"))
    data$date <- NULL

    fromDate <- as.Date("2015-08-07")
    toDate <- as.Date("2016-08-07")

    last12Months <- data[data$date.time >= fromDate & data$date.time <= toDate,]

    ggplot(data=last12Months, aes(x=date.time, y=pips, group = 1)) +
    geom_line() +
    geom_line(aes(y = 50, colour = 'RED')) +
    ggtitle(file.in)
    ggsave(file=file.out)
}
in_files <- list.files('consecutive_out')

sapply(in_files, function(x) generate.plot(x))