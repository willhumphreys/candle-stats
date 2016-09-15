years <- c('2007')
cut_offs <- seq(-100,100, 10)
combinations <- expand.grid(years,cut_offs)

file.in <- 'summary_high_scores.csv'
data <- read.table(file.in, header=T,sep=",")


get.means <- function(year, cut_off, data) {
  print(sprintf("Execute %s %s rows %f", year, cut_off, nrow(data)))
  datax <- data[ data$cut_off_percentage < cut_off ,]
  print(sprintf("After cut-off %f ", nrow(datax)))
  datax <- datax[ datax$start_date == paste(year, '-08-02T00:00:00+00:00', sep="") ,]
  print(sprintf("After year %f ", nrow(datax)))
  mean <- mean(datax$winning_percentage)
  row_count <- nrow(datax)
  print(sprintf('For year %s we have a mean of %f and a count of %f cut off %s', year, mean, row_count, cut_off ))
}

#data <- data[ which(data$data_set=='eurchf_FadeTheBreakoutNormalDaily' ),]


#sapply(years, function(x) get.means(x))

apply(combinations, 1, function(x) get.means(x[1], x[2], data) )