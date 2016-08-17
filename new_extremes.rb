require 'json'
require_relative 'bar_chart_file_repo'
require_relative 'mt4_file_repo'
require_relative 'stat_executor'
require_relative 'candle_operations'
require_relative 'processor'
require_relative 'processors'
require_relative 'news_reader'
require_relative 'mt4_quote_mapper'

@bar_chart_file_repo = BarChartFileRepo.new
@mt4_file_repo = MT4FileRepo.new(Mt4QuoteMapper.new)
@candle_ops = CandleOperations.new
@processors = Processors.new

@new_lows_3 = 0.0
@new_lows_4 = 0.0

@down_days_3 = 0.0
@down_days_4 = 0.0
@down_days_5 = 0.0
@down_days_6 = 0.0

time_periods = %w(10080 1440)
symbols = %w(AUDUSD EURCHF EURGBP EURJPY EURUSD GBPUSD USDCAD USDCHF USDJPY NZDUSD)

data_sets = symbols.product(time_periods).collect { |time_period, symbol| time_period + symbol }

data_sets.each { |data_set|
  quotes = @mt4_file_repo.read_quotes("data/#{data_set}.csv")

  quotes.each_cons(6) do |first, second, third, fourth, fifth, sixth|
    if @candle_ops.is_a_lower_low_in(first, second) && @candle_ops.is_a_lower_low_in(second, third) && @candle_ops.is_a_lower_low_in(third, fourth)
      @new_lows_3 += 1
      if @candle_ops.is_a_lower_low_in(fourth, fifth)
        @new_lows_4 +=1
      end

    end

    if @candle_ops.is_a_down_day(first)  && @candle_ops.is_a_down_day(second) && @candle_ops.is_a_down_day(third)
      @down_days_3 += 1
      if @candle_ops.is_a_down_day(fourth)
        @down_days_4 += 1
        if @candle_ops.is_a_down_day(fifth)
          @down_days_5 += 1
          if @candle_ops.is_a_down_day(sixth)
            @down_days_6 += 1
          end
        end
      end
    end

  end
  puts "#{data_set} "
  puts "3 new lows: #{@new_lows_3} 4 new lows: #{@new_lows_4} Odds on a lower low: #{((@new_lows_4 / @new_lows_3) * 100).round(2)}%"
  puts "3 down days: #{@down_days_3} 4 down days: #{@down_days_4} Odds on a down day: #{((@down_days_4 / @down_days_3) * 100).round(2)}%"
  puts "4 down days: #{@down_days_4} 5 down days: #{@down_days_5} Odds on a down day: #{((@down_days_5 / @down_days_4) * 100).round(2)}%"
  puts "5 down days: #{@down_days_5} 6 down days: #{@down_days_6} Odds on a down day: #{((@down_days_6 / @down_days_5) * 100).round(2)}%"
}

puts 'done'