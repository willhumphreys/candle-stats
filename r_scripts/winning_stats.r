years <- c('2007','2008','2009','2010','2011','2012','2013','2014','2015','2016')
cut_offs <- seq(-100,100, 10)
combinations <- expand.grid(years,cut_offs)

file.in <- 'summary_high_scores.csv'
data <- read.table(file.in, header=T,sep=",")


get.means <- function(year, cut_off, data) {
  cut_off <- as.numeric(cut_off)
  print(typeof(cut_off))
  print(sprintf("Execute %s %s rows %d", year, cut_off, nrow(data)))
  datax <- data[ data$cut_off_percentage < cut_off ,]
  datax <- datax[ datax$cut_off_percentage >= cut_off - 10 ,]
  print(sprintf("After cut-off %d ", nrow(datax)))
  datax <- datax[ datax$start_date == paste(year, '-08-02T00:00:00+00:00', sep="") ,]
  print(sprintf("After year %d ", nrow(datax)))
  mean <- mean(datax$winning_percentage)
  row_count <- nrow(datax)
  print(sprintf('For year %s we have a mean of %f and a count of %d cut off %s', year, mean, row_count, cut_off ))
}

#data <- data[ which(data$data_set=='eurchf_FadeTheBreakoutNormalDaily' ),]


#sapply(years, function(x) get.means(x))

apply(combinations, 1, function(x) get.means(x[1], x[2], data) )