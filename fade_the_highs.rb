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

FileUtils.rm_rf Dir.glob('results/*')

@buy_minimum = 6

@running_moving_average = 10

@total_trade_profit = 0
@total_trade_loss = 0

@winning_symbols = []
@losing_symbols = []

@global_win_count = 0
@global_lose_count = 0

def reset_fields

  @trade_profit = []
  @trade_loss = []

  @running_profit_1_2 = []
  @running365_profit_1_2 = []

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

time_periods = %w(_FadeTheBreakoutNormalDaily_10y)
#time_periods = %w(_NormalDaily10y)
#time_periods = %w(_FadeTheBreakoutNormal_10y)

symbols = %w(audusd eurchf eurgbp eurusd gbpusd usdcad usdchf nzdusd)

data_sets = symbols.product(time_periods).collect { |time_period, symbol| time_period + symbol }

def log_csv(data_set, title, file_out)
  open(file_out, 'a') { |f|
    f << "#{title},#{data_set},profit 1-2,wins,#{((@profit_1_2 / @profit_1) * 100).round(2)}\n"
    f << "#{title},#{data_set},profit 1-2-3,wins,#{((@profit_1_2_3 / @profit_1_2) * 100).round(2)}\n"
    f << "#{title},#{data_set},profit 1-2-3-4,wins,#{((@profit_1_2_3_4 / @profit_1_2_3) * 100).round(2)}\n"
    f << "#{title},#{data_set},profit 1-2-3-4-5,wins,#{((@profit_1_2_3_4_5 / @profit_1_2_3_4) * 100).round(2)}\n"

    f << "#{title},#{data_set},loss 1-2,losses,#{((@loss_1_2 / @loss_1) * 100).round(2)}\n"
    f << "#{title},#{data_set},loss 1-2-3,losses,#{((@loss_1_2_3 / @loss_1_2) * 100).round(2)}\n"
    f << "#{title},#{data_set},loss 1-2-3-4,losses,#{((@loss_1_2_3_4 / @loss_1_2_3) * 100).round(2)}\n"
    f << "#{title},#{data_set},loss 1-2-3-4-5,losses,#{((@loss_1_2_3_4_5 / @loss_1_2_3_4) * 100).round(2)}\n"

    #f << "#{title},#{data_set},profit 100 day,#{@running100_profit_1_2.inject(0, :+)}\n"


  }

end

def process(data_set, profits, title, start_date, end_date, directory_out, file_out)
  profits.each_cons(6) do |first, second, third, fourth, fifth, sixth|

    if first.timestamp.utc < start_date || first.timestamp.utc > end_date
      next
    end

    trade_on = false

    #if @running_profit_1_2.inject(0, :+) == @buy_minimum && @running_profit_1_2.first == 1
    if @running_profit_1_2.inject(0, :+) == @buy_minimum
      trade_on = true
    end

    if first.profit > 0
      @global_win_count += 1
      if trade_on
        @trade_profit.push(1)

       # puts 'win'
      end

      @profit_1 += 1
      @running_profit_1_2.push(1)
      if second.profit > 0
      #  @running_profit_1_2.push(1)
        @profit_1_2 += 1
        if third.profit > 0
          #@running_profit_1_2.push(1)
          @profit_1_2_3 += 1
          if fourth.profit > 0
            @profit_1_2_3_4 += 1
            if fifth.profit > 0
              @profit_1_2_3_4_5 += 1
            end
          end
        else
          #@running_profit_1_2.push(-1)
        end
      else
       # @running_profit_1_2.push(-1)
      end
    else
      @global_lose_count += 1
      if trade_on

       # puts 'loss'
        @trade_loss.push(1)

      end

      @running_profit_1_2.push(-1)
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



    if @running_profit_1_2.size > @running_moving_average
      @running_profit_1_2 = @running_profit_1_2.drop(1)

      open("#{directory_out}/r#{@running_moving_average}_#{file_out}", 'a') { |f|
        f << "#{first.timestamp.strftime('%Y/%m/%d')},#{title},#{@running_profit_1_2.inject(0, :+)},#{@running_profit_1_2.last},#{@running_profit_1_2.join('')}\n"
      }

    end
  end

  puts "#{title} #{start_date.strftime('%Y/%m/%d')} #{end_date.strftime('%Y/%m/%d')}"
  puts "win  #{@trade_profit.join('')}"
  puts "lose #{@trade_loss.join('')}"

  @total_trade_profit += @trade_profit.size
  @total_trade_loss += @trade_loss.size

  if @trade_profit.size > @trade_loss.size
    @winning_symbols.push("#{file_out.split('_').first}:#{title.split(' ').last}")
  elsif @trade_profit.size < @trade_loss.size
    @losing_symbols.push("#{file_out.split('_').first}:#{title.split(' ').last}")
  end

  log_csv(data_set, title, "#{directory_out}/#{file_out}")

  reset_fields

end

def generate_stats(data_set, end_date, fail_at_highs, fail_at_lows, start_date)
  directory_out = 'results'
  file_out = "#{data_set}-#{start_date.strftime('%Y-%m-%d')}-#{end_date.strftime('%Y-%m-%d')}.csv"
  File.delete("#{directory_out}/#{file_out}") if File.exist?(file_out)
  open("#{directory_out}/#{file_out}", 'a') { |f|
    f << "scenario, data_set, consecutive, fails_or_wins, result\n"
  }

  open("#{directory_out}/r#{@running_moving_average}_#{file_out}", 'a') { |f|
    f << "date,direction,moving_average,last,array\n"
  }

  process(data_set, fail_at_highs, 'fail at highs', start_date, end_date, directory_out, file_out)
  process(data_set, fail_at_lows, 'fail at lows', start_date, end_date, directory_out, file_out)
end

data_sets.each { |data_set|

  profits = @mt4_file_repo.read_quotes("backtesting_data/#{data_set}.csv")

  fail_at_highs = profits.select do |profit|
    profit.direction == 'short'
  end

  fail_at_lows = profits.select do |profit|
    profit.direction == 'long'
  end

  # 8.times do |count|
  #   start_date = DateTime.now - 12.months - (12 * count).months
  #   end_date = DateTime.now - (12 * count).months
  #
  #   generate_stats(data_set, end_date, fail_at_highs, fail_at_lows, start_date)
  #
  # end

  1.times do |count|
    # start_date = DateTime.new(2016,8,5) - (12 * 12).months
    # end_date = DateTime.new(2016,8,5)

    start_date = DateTime.new(2016,8,5) - (12 * 8).months
    end_date = DateTime.new(2016,8,5) - (12 * 6).months

    generate_stats(data_set, end_date, fail_at_highs, fail_at_lows, start_date)

  end


}

percentage_win_lose = ((@total_trade_profit.to_f / (@total_trade_loss + @total_trade_profit.to_f)) * 100).round(2)
puts "Buy minimum: #{@buy_minimum}"
puts "Total profit: #{@total_trade_profit} Total loss: #{@total_trade_loss} Percentage: #{percentage_win_lose}%"
puts "Winning Symbols:#{@winning_symbols.size} #{@winning_symbols.join(' ')} \nLosing Symbols:#{@losing_symbols.size} #{@losing_symbols.join(' ')}"
puts 'done'

global_percentage_win_lose = ((@global_win_count.to_f / (@global_lose_count + @global_win_count)) * 100).round(2)
puts "Global win count: #{@global_win_count} Global lose count: #{@global_lose_count} winning percentage #{global_percentage_win_lose}"