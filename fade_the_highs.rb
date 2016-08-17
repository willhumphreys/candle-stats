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

@fail_1 = 0.0
@fail_2 = 0.0
@fail_3 = 0.0
@fail_4 = 0.0
@fail_5 = 0.0
@fail_6 = 0.0

@win_1 = 0.0
@win_2 = 0.0
@win_3 = 0.0
@win_4 = 0.0
@win_5 = 0.0
@win_6 = 0.0

@profit_alternates = 0.0

time_periods = %w(_FadeTheBreakoutNormal)

symbols = %w(AUDUSD EURCHF EURGBP EURUSD GBPUSD USDCAD USDCHF NZDUSD)

data_sets = symbols.product(time_periods).collect { |time_period, symbol| time_period + symbol }

def process(data_set, profits, title)
  profits.each_cons(6) do |first, second, third, fourth, fifth, sixth|
    if first.profit < 0
      @fail_1 += 1
      if second.profit < 0
        @fail_2 += 1
        if third.profit < 0
          @fail_3 += 1
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
    end

    if first.profit > 0
      @win_1 += 1
      if second.profit > 0
        @win_2 += 1
        if third.profit > 0
          @win_3 += 1
          if fourth.profit > 0
            @win_4 += 1
            if fifth.profit > 0
              @win_5 += 1
              if sixth.profit > 0
                @win_6 += 1
              end
            end
          end
        end
      end
    end

    if (first.profit > 0 && second.profit < 0) || (first.profit < 0 && second.profit > 0)
      @profit_alternates+=1
    end



  end

  puts "profit alternates #{(@profit_alternates / (@win_2 + @fail_2)).round(2) }"

  puts "#{title} #{data_set} fails"
  puts "1 fail: #{@fail_1} 2 consecutive fails: #{@fail_2} Odds the 2 fail in a row #{((@fail_2 / @fail_1) * 100).round(2)}%"
  puts "3 consecutive fails: #{@fail_3} 4 consecutive fails: #{@fail_4} Odds the 4th consecutive fail: #{((@fail_4 / @fail_3) * 100).round(2)}%"
  puts "4 consecutive fails: #{@fail_4} 5 consecutive fails: #{@fail_5} Odds the 5th consecutive fail: #{((@fail_5 / @fail_4) * 100).round(2)}%"
  puts "5 consecutive fails: #{@fail_5} 6 consecutive fails: #{@fail_6} Odds the 6th consecutive fail: #{((@fail_6 / @fail_5) * 100).round(2)}%"

  puts "#{title} #{data_set} wins"
  puts "1 win: #{@win_1} 2 consecutive wins: #{@win_2} Odds the 2 win in a row #{((@win_2 / @win_1) * 100).round(2)}%"
  puts "3 consecutive wins: #{@win_3} 4 consecutive wins: #{@win_4} Odds the 4th consecutive win: #{((@win_4 / @win_3) * 100).round(2)}%"
  puts "4 consecutive wins: #{@win_4} 5 consecutive wins: #{@win_5} Odds the 5th consecutive win: #{((@win_5 / @win_4) * 100).round(2)}%"
  puts "5 consecutive wins: #{@win_5} 6 consecutive wins: #{@win_6} Odds the 6th consecutive win: #{((@win_6 / @win_5) * 100).round(2)}%"
end

data_sets.each { |data_set|
  profits = @mt4_file_repo.read_quotes("data/#{data_set}.csv")

  fail_at_highs = profits.select do |profit|
    profit.direction == 'short'
  end

  fail_at_lows = profits.select do |profit|
    profit.direction == 'long'
  end

  process(data_set, profits, 'both')
  process(data_set, fail_at_highs, 'fail at highs')
  process(data_set, fail_at_lows, 'fail at lows')
}

puts 'done'