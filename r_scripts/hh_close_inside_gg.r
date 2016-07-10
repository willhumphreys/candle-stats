library(SparseM)
library(ggplot2)
library(quantreg)
library(plyr)
library(ggthemes)

generate.plot <- function(file.in, file.out, plot.title, plot.step, plot.high) {
    data <- read.table(file.in, header=T,sep=",")
    data$fixed.date.time=as.POSIXct(data$date.time, tz = "UTC")
    data$date.time <- data$fixed.date.time
    data$fixed.date.time <- NULL
    fit.50 <- quantreg::rq(pips ~ splines::bs(date.time, df=15), tau=0.50, data=data)
    fit.80 <- quantreg::rq(pips ~ splines::bs(date.time, df=15), tau=0.80, data=data)
    fit.20 <- quantreg::rq(pips ~ splines::bs(date.time, df=15), tau=0.20, data=data)
    data$pc.50 = predict(fit.50)
    data$pc.20 = predict(fit.20)
    data$pc.80 = predict(fit.80)

    q20 <- quantile(data$pips, .20)
    q50 <- quantile(data$pips, .50)
    q80 <- quantile(data$pips, .80)

    plot <- ggplot(data, aes(x = date.time)) +
    geom_point(aes(y = pips)) +

    geom_line(aes(y = pc.80, colour = '80th percentile')) +
    geom_line(aes(y = pc.20, colour = '20th percentile')) +
    geom_line(aes(y = pc.50, colour = 'Median')) +
    geom_hline(aes(yintercept = q20, colour = '20th percentile')) +
    geom_hline(aes(yintercept = q50, colour = 'Median')) +
    geom_hline(aes(yintercept = q80, colour = '80th percentile')) +

    scale_y_continuous(breaks=seq(0, plot.high, plot.step))  +
    guides(fill=guide_legend(title=NULL)) +
    labs(x="Date",y="Pips") +
    theme_solarized() +
    ggtitle(plot.title) +
    theme(legend.title=element_blank())

    ggsave(file=file.out)
}

generate.plot("out/higher_high_close_in_range.csv",
    "plots/higher_high_close_in_range.png",
    "Break outside and close back inside AUDUSD Weekly",
    10, 250
    )

generate.plot("out/higher_high_close_above.csv",
    "plots/higher_high_close_above.png",
    "Break above and hold AUDUSD Weekly",
    20, 500
    )

generate.plot("out/lower_low_close_in_range.csv",
    "plots/lower_low_close_in_range.png",
    "Break below and close back inside AUDUSD Weekly",
    10, 300
    )

generate.plot("out/lower_low_close_below.csv",
    "plots/lower_low_close_below.png",
    "Break below and hold AUDUSD Weekly",
    40, 1500
    )