library(ggplot2)
data <- read.table('out.csv', header=T,sep=",")

generate.plot <- function(symbol, data) {
  data_for_symbol <- subset(data, data_set == symbol)

  ggplot(data=data_for_symbol, aes(x=consecutive, y=result, fill=scenario)) +geom_bar(stat="identity", position=position_dodge()) + theme(axis.text.x = element_text(angle = 90, hjust = 1))
  ggsave(file=paste('fade_highs_low_graphs/', symbol, ".png", sep = ""))
}


scenarios <- c("FadeTheBreakoutNormal")
symbols <- c("AUDUSD", "EURCHF", "EURGBP", "EURUSD", "GBPUSD", "NZDUSD", "USDCHF")


scenario_symbols <- expand.grid(symbols, scenarios)

combinations <- paste(scenario_symbols$Var1, scenario_symbols$Var2, sep="_")

sapply(combinations, function(combination) generate.plot(combination, data))