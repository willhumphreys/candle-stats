library(ggplot2)
data <- read.table('out.csv', header=T,sep=",")
data$plot.name <- paste(data$scenario,'-',data$data_set,'-',data$consecutive, '-', data$fails_or_wins)
ggplot(data=data, aes(x=plot.name, y=result, fill=scenario)) +geom_bar(stat="identity")

audusd <- subset(data, data_set == " AUDUSD_FadeTheBreakoutNormal")
ggplot(data=audusd, aes(x=plot.name, y=result, fill=scenario)) +geom_bar(stat="identity") + theme(axis.text.x = element_text(angle = 90, hjust = 1))
