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

def reset_fields

  @second_profit = 0.0
  @second_loss = 0.0

  @first_profit_and_second_loss = 0.0
  @first_loss_and_second_profit = 0.0
  @first_loss_and_second_profit = 0.0

  @profit_1 = 0.0
  @profit_1_2 = 0.0
  @profit_1_2_3 = 0.0
  @profit_1_2_3_4 = 0.0
  @profit_1_2_3_4_5 = 0.0

  @loss_1 = 0.0
  @loss_1_2 = 0.0
  @loss_1_2_3 = 0.0
  @loss_1_2_3_4 = 0.0
  @loss_1_2_3_4_5 = 0.0

end

reset_fields

time_periods = %w(_FadeTheBreakoutNormal)

symbols = %w(AUDUSD EURCHF EURGBP EURUSD GBPUSD USDCAD USDCHF NZDUSD)

data_sets = symbols.product(time_periods).collect { |time_period, symbol| time_period + symbol }

File.delete('out.csv') if File.exist?('out.csv')
open('out.csv', 'a') { |f|
  f << "scenario, data_set, consecutive, fails_or_wins, result\n"
}

def log_csv(data_set, title)
  open('out.csv', 'a') { |f|
    f << "#{title},#{data_set},profit 1 (#{@profit_1}) - odds 2 profit (#{@profit_1_2}), wins,#{((@profit_1_2 / @profit_1) * 100).round(2)}\n"
    f << "#{title},#{data_set},profit 1-2 (#{@profit_1_2}) - odds 3 profit (#{@profit_1_2_3}), wins,#{((@profit_1_2_3 / @profit_1_2) * 100).round(2)}\n"
    f << "#{title},#{data_set},profit 1-2-3 (#{@profit_1_2_3}) - odds 4 profit (#{@profit_1_2_3_4}), wins,#{((@profit_1_2_3_4 / @profit_1_2_3) * 100).round(2)}\n"
    f << "#{title},#{data_set},profit 1-2-3-4 (#{@profit_1_2_3_4}) - odds 5 profit (#{@profit_1_2_3_4_5}), wins,#{((@profit_1_2_3_4_5 / @profit_1_2_3_4) * 100).round(2)}\n"

    f << "#{title},#{data_set},loss 1 (#{@loss_1}) - odds 2 loss (#{@loss_1_2}), losses,#{((@loss_1_2 / @loss_1) * 100).round(2)}\n"
    f << "#{title},#{data_set},loss 1-2 (#{@loss_1_2}) - odds 3 loss (#{@loss_1_2_3}), losses,#{((@loss_1_2_3 / @loss_1_2) * 100).round(2)}\n"
    f << "#{title},#{data_set},loss 1-2-3 (#{@loss_1_2_3}) - odds 4 loss (#{@loss_1_2_3_4}), losses,#{((@loss_1_2_3_4 / @loss_1_2_3) * 100).round(2)}\n"
    f << "#{title},#{data_set},loss 1-2-3-4 (#{@loss_1_2_3_4}) - odds 5 loss (#{@loss_1_2_3_4_5}), losses,#{((@loss_1_2_3_4_5 / @loss_1_2_3_4) * 100).round(2)}\n"
  }

end

def process(data_set, profits, title)
  profits.each_cons(6) do |first, second, third, fourth, fifth, sixth|
    if first.profit > 0
      @profit_1 += 1
      if second.profit > 0
        @profit_1_2 += 1
        if third.profit > 0
          @profit_1_2_3 += 1
          if fourth.profit > 0
            @profit_1_2_3_4 += 1
            if fifth.profit > 0
              @profit_1_2_3_4_5 += 1
            end
          end
        end
      end
    end

    if first.profit < 0
      @loss_1 += 1
      if second.profit < 0
        @loss_1_2 += 1
        if third.profit < 0
          @loss_1_2_3 += 1
          if fourth.profit < 0
            @loss_1_2_3_4 += 1
            if fifth.profit < 0
              @loss_1_2_3_4_5 += 1
            end
          end
        end
      end
    end
  end


  log_csv(data_set, title)

  reset_fields

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