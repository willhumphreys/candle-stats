require 'json'
require_relative 'bar_chart_file_repo'
require_relative 'mt4_file_repo'
require_relative 'stat_executor'
require_relative 'candle_operations'
require_relative 'processor'
require_relative 'processors'
require_relative 'news_reader'
require_relative 'fade_mapper'

@bar_chart_file_repo = BarChartFileRepo.new
@mt4_file_repo = MT4FileRepo.new(FadeMapper.new)
@candle_ops = CandleOperations.new
@processors = Processors.new

@fail_3 = 0.0
@fail_4 = 0.0
@fail_5 = 0.0
@fail_6 = 0.0

time_periods = %w(_FadeTheBreakoutNormal)

symbols = %w(AUDUSD EURCHF EURGBP EURUSD GBPUSD USDCAD USDCHF NZDUSD)

data_sets = symbols.product(time_periods).collect { |time_period, symbol| time_period + symbol }

def process(data_set, profits)
  profits.each_cons(6) do |first, second, third, fourth, fifth, sixth|
    if first.profit < 0 && second.profit < 0 && third.profit < 0
      @fail_3 +=1
      if fourth.profit < 0
        @fail_4 += 1
        if fifth.profit < 0
          @fail_5 += 1
          if sixth.profit < 0
            @fail_6 += 1
          end
        end
      end
    end

  end
  puts "#{data_set} "
  puts "3 consecutive fails: #{@fail_3} 4 consecutive fails: #{@fail_4} Odds the 4th consecutive fail: #{((@fail_4 / @fail_3) * 100).round(2)}%"
  puts "4 consecutive fails: #{@fail_4} 5 consecutive fails: #{@fail_5} Odds the 5th consecutive fail: #{((@fail_5 / @fail_4) * 100).round(2)}%"
  puts "5 consecutive fails: #{@fail_5} 5 consecutive fails: #{@fail_6} Odds the 5th consecutive fail: #{((@fail_6 / @fail_5) * 100).round(2)}%"
end

data_sets.each { |data_set|
  profits = @mt4_file_repo.read_quotes("data/#{data_set}.csv")

  fail_at_highs = profits.select do |profit|
    profit.direction == 'short'
  end

  fail_at_lows = profits.select do |profit|
    profit.direction == 'long'
  end

  process(data_set, profits)
  process(data_set, fail_at_highs)
  process(data_set, fail_at_lows)
}

puts 'done'