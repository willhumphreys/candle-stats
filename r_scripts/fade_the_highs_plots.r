library(ggplot2)

process <- function(file.in) {

  data <- read.table(paste('fade_ruby_out/',file.in, sep = ""), header=T,sep=",")

  generate.plot <- function(data) {

    ggplot(data=data, aes(x=consecutive, y=result, fill=scenario)) +geom_bar(stat="identity", position=position_dodge()) + theme(axis.text.x = element_text(angle = 90, hjust = 1))
    ggsave(file=paste('fade_highs_low_graphs/',file.in, ".png", sep = ""))
  }
   generate.plot(data)
}

in_files <- list.files('fade_ruby_out')
sapply(in_files, function(file.in) process(file.in))