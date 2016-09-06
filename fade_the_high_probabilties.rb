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
require 'active_support/all'

@bar_chart_file_repo = BarChartFileRepo.new
@mt4_file_repo = MT4FileRepo.new(FadeMapper.new)
@candle_ops = CandleOperations.new
@processors = Processors.new
@date_range_generator = DateRangeGenerator.new(DateTime.new(2007, 12, 5), DateTime.new(2016, 8, 2))

input_directory = 'backtesting_data'
output_directory = 'could_of_been_better_results'
FileUtils.rm_rf Dir.glob("#{output_directory}/*")
summary_file = "#{output_directory}/summary_high_scores.csv"
File.delete(summary_file) if File.exist?(summary_file)

moving_average_counts = 2.step(36, 2).to_a # How big is the moving average window.
cut_offs = -34.step(34, 1).to_a # How successful do the trades need to be.
minimum_profits = 2.step(36, 2).to_a # What is the minimum profit our new trade needs to be traded.

end_of_data_in_file = %w(_FadeTheBreakoutNormalDaily)
symbols = %w(audusd)
data_sets = symbols.product(end_of_data_in_file).collect { |time_period, symbol| time_period + symbol }

date_ranges = @date_range_generator.get_ranges

open(summary_file, 'a') { |f|
  f << 'start_date,end_date,data_set,minimum_profit,cut_off,moving_average_count,winners.size,losers.size,'\
       "winning_percentage,cut_off_percentage\n"
}


def process_data_set(required_score, data_set, end_date, input_directory, minimum_profit, window_size, start_date, summary_file)
  puts data_set

  trade_results = @mt4_file_repo.read_quotes("#{input_directory}/#{data_set}.csv")

  stored_trades = []
  winners = []
  losers = []
  trade_on = false

  trade_results.each { |trade_result|

    if trade_result.timestamp.utc < start_date || trade_result.timestamp.utc > end_date || trade_result.profit.abs < minimum_profit
      next
    end

    if trade_on
      if stored_trades.size >= window_size
        if trade_result.profit >= 0
          winners.push(1)
        else
          losers.push(1)
        end
        trade_on = false
      end
    end

    if trade_result.profit > 0
      stored_trades.push(1)
    else
      stored_trades.push(-1)
    end

    if stored_trades.size > window_size
      stored_trades = stored_trades.drop(1)
    end

    stored_trades_score = stored_trades.inject(0, :+)
    if (required_score >= 0 && stored_trades_score >= required_score) ||
        (required_score < 0 && stored_trades_score <= required_score)
      trade_on = true
    end
  }

  if !losers.empty? || !winners.empty?

    winning_percentage = ((winners.size.to_f / (losers.size + winners.size)) * 100).round(2)
    cut_off_percentage = ((required_score.to_f / window_size) * 100).round(2)
    puts "#{start_date}-#{end_date} #{data_set } minimum_profit: #{minimum_profit} cut off: #{required_score} "\
               "moving average count: #{window_size} winners: #{winners.size} losers: #{losers.size} "\
               "#{winning_percentage}% cut off percentage: #{cut_off_percentage}"
    puts stored_trades.join('')

    open(summary_file, 'a') { |f|
      f << "#{start_date},#{end_date},#{data_set},#{minimum_profit},#{required_score},#{window_size},"\
                 "#{winners.size},#{losers.size},#{winning_percentage},#{cut_off_percentage}\n"
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

          process_data_set(required_score, data_set, end_date, input_directory, minimum_profit, window_size, start_date, summary_file)
        }
      }
    }
  }
}
