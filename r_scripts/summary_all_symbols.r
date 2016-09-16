library(data.table)
library(ggplot2)
file.in <- 'summary_all_symbols_20P.csv'
data <- read.table(file.in, header=T,sep=",", row.names=NULL)

ggplot(data=data, aes(x=year, y=winning_percentage, group=cut_off, color=factor(cut_off))) +
    geom_line() +
    scale_y_continuous(breaks=seq(0,100,5)) +
    ggtitle("Different Cut-offs 20P") +
    geom_point()
ggsave(file='summary_all_symbols_20P.png')