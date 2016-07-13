require 'json'
require_relative 'bar_chart_file_repo'
require_relative 'mt4_file_repo'
require_relative 'stat_executor'
require_relative 'candle_operations'
require_relative 'processor'

@bar_chart_file_repo = BarChartFileRepo.new
@mt4_file_repo = MT4FileRepo.new
@candle_ops = CandleOperations.new

higher_high_close_above_l = lambda do |first, second|
  if @candle_ops.is_a_higher_high_in(first, second) && @candle_ops.closes_above_range(first, second)
    return ((second.high - first.high) * 10000).round(0)
  end
  return nil
end

higher_high_close_inside_l = lambda do |first, second|
  if @candle_ops.is_a_higher_high_in(first, second) && @candle_ops.closes_inside_range(first, second)
    return ((second.high - first.high) * 10000).round(0)
  end
  nil
end

lower_low_close_below_l = lambda do |first, second|
  if @candle_ops.is_a_lower_low_in(first, second) && @candle_ops.closes_below_range(first, second)
    return ((second.low - first.low) * 10000).round(0)
  end
  return nil
end

lower_low_close_inside_l = lambda do |first, second|
  if @candle_ops.is_a_lower_low_in(first, second) && @candle_ops.closes_inside_range(first, second)
    return ((second.low - first.low) * 10000).round(0)
  end
  nil
end

time_periods = ['10080']
symbols = ['AUDUSD']

data_sets = symbols.product(time_periods).collect { |time_period, symbol| time_period + symbol }

data_sets.each { |data_set|
  quotes = @mt4_file_repo.read_quotes("data/#{data_set}.csv")

  executors = [Stat_Executor.new(data_set, Processor.new('higher_high_close_above', higher_high_close_above_l)),
               Stat_Executor.new(data_set, Processor.new('higher_high_close_inside', higher_high_close_inside_l)),
               Stat_Executor.new(data_set, Processor.new('lower_low_close_above', lower_low_close_below_l)),
               Stat_Executor.new(data_set, Processor.new('lower_low_close_inside', lower_low_close_inside_l))]


  quotes.each_cons(6) do |first, second, third, fourth, fifth, sixth|

    executors.each { |executor|
      executor.process_and_write(first, second)
    }

  end
}

puts 'done'