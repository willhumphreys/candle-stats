library(data.table)
library(ggplot2)
dir.in <- 'results/'
file.in <- 'FadeTheBreakoutNormalDaily-2007-08-02-2016-08-02-9-4_win_lose.csv'
data <- read.table(paste(dir.in,file.in, sep=''), header=T,sep=",", row.names=NULL)



data$date=as.Date(as.POSIXct(data$date, tz = "UTC", format="%Y-%m-%dT%H:%M:%S"))

data <- data[order(data$date),]


data <- within(data, {
  cumsum_profit_loss <- ave(profit_lose, symbol, FUN = cumsum)
})

colourCount = 10
getPalette = colorRampPalette(brewer.pal(9, "Set1"))

ggplot(data=data, aes(x=date, y=cumsum_profit_loss, group = symbol, colour=symbol)) +
    geom_line() +
    geom_point() +
    scale_y_continuous(breaks=seq(-30,30,1)) +

    ggtitle(file.in)
    ggsave(file=paste('cumsum_profits/', file.in,'.png', sep=''))