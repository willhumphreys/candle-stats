library('ggthemes')
library('ggplot2')

data <- read.table('could_of_been_better_results/summary_high_scores.csv', header=T,sep=",")


ggplot(data, aes(x=cut_off_percentage, y=winning_percentage)) +
    geom_point(shape=1)  +    # Use hollow circles

      stat_density2d(aes(fill = ..level..), geom="polygon")


      # sp + geom_density2d()
      #
      #  + stat_ellipse()
      #
      #  http://www.sthda.com/english/wiki/ggplot2-scatter-plots-quick-start-guide-r-software-and-data-visualization