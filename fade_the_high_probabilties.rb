require 'json'
require_relative 'bar_chart_file_repo'
require_relative 'mt4_file_repo'
require_relative 'stat_executor'
require_relative 'candle_operations'
require_relative 'processor'
require_relative 'processors'
require_relative 'news_reader'
require_relative 'fade_mapper'
require 'active_support/all'

@bar_chart_file_repo = BarChartFileRepo.new
@mt4_file_repo = MT4FileRepo.new(FadeMapper.new)
@candle_ops = CandleOperations.new
@processors = Processors.new

output_directory = 'could_of_been_better_results'
FileUtils.rm_rf Dir.glob("#{output_directory}/*")
summary_file = "#{output_directory}/summary_high_scores.csv"
File.delete(summary_file) if File.exist?(summary_file)

moving_average_counts = 2.step(36, 2).to_a

time_periods = %w(_FadeTheBreakoutNormalDaily)

symbols = %w(audusd eurchf eurgbp eurusd gbpusd usdcad usdchf nzdusd usdjpy eurjpy)

data_sets = symbols.product(time_periods).collect { |time_period, symbol| time_period + symbol }

cut_offs = -34.step(34, 1).to_a

open(summary_file, 'a') { |f|
  f << "data_set,minimum_profit,cut_off,moving_average_count,winners.size,losers.size,winning_percentage,cut_off_percentage\n"
}

minimum_profits = 2.step(36, 2).to_a

minimum_profits.each { |minimum_profit|

  cut_offs.each { |cut_off|

    moving_average_counts.each { |moving_average_count|

      if cut_off.abs >= moving_average_count
        next
      end

      data_sets.each { |data_set|

        puts data_set

        profits = @mt4_file_repo.read_quotes("backtesting_data/#{data_set}.csv")

        results = []

        trade_on = false

        winners = []
        losers = []

        profits.each { |first|

          # if first.profit < 0
          #   next
          # end

          if trade_on
            if first.profit >= minimum_profit
              winners.push(first.could_of_been_better)
            else
              losers.push(first.could_of_been_better)
            end
            trade_on = false
          end


          if first.profit > minimum_profit
            results.push(1)
          else
            results.push(-1)
          end

          if results.size > moving_average_count
            results = results.drop(1)
          end

          if results.inject(0, :+) > cut_off
            trade_on = true
          end

        }

        winning_percentage = ((winners.size.to_f / (losers.size + winners.size)) * 100).round(2)
        cut_off_percentage_of_moving_average = ((cut_off.to_f / moving_average_count) * 100).round(2)
        puts "#{data_set } minimum_profit: #{minimum_profit} cut off: #{cut_off} moving average count: #{moving_average_count} winners: #{winners.size} losers: #{losers.size} #{winning_percentage}% cut off percentage: #{cut_off_percentage_of_moving_average}"
        puts results.join('')

        open(summary_file, 'a') { |f|
          f << "#{data_set},#{minimum_profit},#{cut_off},#{moving_average_count},#{winners.size},#{losers.size},#{winning_percentage},#{cut_off_percentage_of_moving_average}\n"
        }

      }
    }

  }
}
