library(SparseM)
library(ggplot2)
library(quantreg)
library(plyr)
library(ggthemes)

generate.plot <- function(file.in, file.out, plot.title, quantile_file) {
    data <- read.table(file.in, header=T,sep=",")
    #sink(NULL)
    data$fixed.date.time=as.POSIXct(data$date.time, tz = "UTC")
    data$date.time <- data$fixed.date.time
    data$fixed.date.time <- NULL

    symbol_name_with_path <- (strsplit(file.in, ".", fixed=TRUE)[[1]])[1]
    symbol_name <- (strsplit(symbol_name_with_path, "/", fixed=TRUE)[[1]])[2]

    sd3 <- sd(data$pips) * 3
    data_cleaned <- (data[ which(abs(data$pips) < sd3),])

    fit.50 <- quantreg::rq(pips ~ splines::bs(date.time, df=15), tau=0.50, data=data_cleaned)
    fit.80 <- quantreg::rq(pips ~ splines::bs(date.time, df=15), tau=0.80, data=data_cleaned)
    fit.20 <- quantreg::rq(pips ~ splines::bs(date.time, df=15), tau=0.20, data=data_cleaned)
    data_cleaned$pc.50 = predict(fit.50)
    data_cleaned$pc.20 = predict(fit.20)
    data_cleaned$pc.80 = predict(fit.80)

    q20 <- quantile(data_cleaned$pips, .20)
    q50 <- quantile(data_cleaned$pips, .50)
    q80 <- quantile(data_cleaned$pips, .80)

    fileConn<-file(quantile_file)

    write(paste(symbol_name, toString(q20), toString(q50), toString(q80), sep=","), file="r_out/quantiles.csv", append=TRUE)
    close(fileConn)

    plot <- ggplot(data_cleaned, aes(x = date.time)) +
    geom_point(aes(y = pips)) +

    geom_line(aes(y = pc.80, colour = '80th percentile')) +
    geom_line(aes(y = pc.20, colour = '20th percentile')) +
    geom_line(aes(y = pc.50, colour = 'Median')) +
    geom_hline(aes(yintercept = q20, colour = '20th percentile')) +
    geom_hline(aes(yintercept = q50, colour = 'Median')) +
    geom_hline(aes(yintercept = q80, colour = '80th percentile')) +
    guides(fill=guide_legend(title=NULL)) +
    labs(x="Date",y="Pips") +
    theme_solarized() +
    ggtitle(plot.title) +
    theme(legend.title=element_blank())

    ggsave(file=file.out)
}


in_files <- list.files('out')

file_names <- sapply(strsplit(in_files, split='.', fixed=TRUE), function(x) (x[1]))

generate.file.in <- function(x) {
    return(paste("out/", x, ".csv", sep = ""))
}

generate.image.out <- function(x) {
    return(paste("plots/", x, ".png", sep = ""))
}

quantile_file <- "r_out/quantiles.csv"

if (file.exists(quantile_file)) file.remove(quantile_file)

write('symbol,P20,P50,P80', file=quantile_file, append=TRUE)

sapply(file_names, function(x) generate.plot(generate.file.in(x), generate.image.out(x), x , quantile_file))