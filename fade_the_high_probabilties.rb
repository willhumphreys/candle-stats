require 'json'
require_relative 'bar_chart_file_repo'
require_relative 'mt4_file_repo'
require_relative 'stat_executor'
require_relative 'candle_operations'
require_relative 'processor'
require_relative 'processors'
require_relative 'news_reader'
require_relative 'fade_mapper'
require_relative 'date_range_generator'
require_relative 'data_set_processor'
require_relative 'results'
require 'active_support/all'

@bar_chart_file_repo = BarChartFileRepo.new
@mt4_file_repo = MT4FileRepo.new(FadeMapper.new)
@candle_ops = CandleOperations.new
@processors = Processors.new
@date_range_generator = DateRangeGenerator.new(DateTime.new(2007, 12, 5), DateTime.new(2016, 8, 2))

@output_directory = 'could_of_been_better_results'
@input_directory = 'backtesting_data'
@summary_file = "#{@output_directory}/summary_high_scores.csv"

output_directory = 'could_of_been_better_results'
FileUtils.rm_rf Dir.glob("#{output_directory}/*")
summary_file = "#{output_directory}/summary_high_scores.csv"
File.delete(summary_file) if File.exist?(summary_file)

moving_average_counts = 2.step(36, 2).to_a # How big is the moving average window.
cut_offs = -34.step(34, 1).to_a # How successful do the trades need to be.
minimum_profits = 2.step(36, 2).to_a # What is the minimum profit our new trade needs to be traded.

end_of_data_in_file = %w(_FadeTheBreakoutNormalDaily)
symbols = %w(audusd eurchf eurgbp eurusd gbpusd usdcad usdchf nzdusd usdjpy eurjpy)
data_sets = symbols.product(end_of_data_in_file).collect { |time_period, symbol| time_period + symbol }

date_ranges = @date_range_generator.get_ranges

open(summary_file, 'a') { |f|
  f << 'start_date,end_date,data_set,minimum_profit,cut_off,moving_average_count,winners.size,losers.size,'\
       "winning_percentage,cut_off_percentage\n"
}

def process_data_set(data_set, required_score, start_date, end_date, minimum_profit, window_size)

  data_set_processor = DataSetProcessor.new(data_set, required_score, start_date, end_date, minimum_profit, window_size)

  trade_results = @mt4_file_repo.read_quotes("#{@input_directory}/#{data_set}.csv")

  results = data_set_processor.process(trade_results)

  unless results.nil?
    puts "#{start_date}-#{end_date} #{data_set } minimum_profit: #{minimum_profit} cut off: #{required_score} "\
               "moving average count: #{window_size} winners: #{results.winners.size} losers: #{results.losers.size} "\
               "#{results.winning_percentage}% cut off percentage: #{results.cut_off_percentage}"


    open(@summary_file, 'a') { |f|
      f << "#{start_date},#{end_date},#{data_set},#{minimum_profit},#{required_score},#{window_size},"\
                 "#{results.winners.size},#{results.losers.size},#{results.winning_percentage},#{results.cut_off_percentage}\n"
    }
  end

end

minimum_profits.each { |minimum_profit|

  cut_offs.each { |required_score|

    moving_average_counts.each { |window_size|

      date_ranges.each { |date_range|

        start_date = date_range.start_date
        end_date = date_range.end_date

        if required_score.abs >= window_size
          next
        end

        data_sets.each { |data_set|

          process_data_set(data_set, required_score, start_date, end_date, minimum_profit, window_size)
        }
      }
    }
  }
}
