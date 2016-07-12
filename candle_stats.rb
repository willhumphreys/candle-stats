require 'json'
require_relative 'bar_chart_file_repo'
require_relative 'mt4_file_repo'
require_relative 'stat_executor'
require_relative 'candle_operations'

@bar_chart_file_repo = BarChartFileRepo.new
@mt4_file_repo = MT4FileRepo.new
@candle_ops = CandleOperations.new

quotes = @mt4_file_repo.read_quotes('data/AUDUSD10080.csv')

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

@higher_high_close_above = Stat_Executor.new('AUDUSDWeekly', higher_high_close_above_l, 'higher_high_close_above')
@higher_high_close_inside = Stat_Executor.new('AUDUSDWeekly', higher_high_close_inside_l, 'higher_high_close_inside')
@lower_low_close_above = Stat_Executor.new('AUDUSDWeekly', lower_low_close_below_l, 'lower_low_close_above')
@lower_low_close_inside = Stat_Executor.new('AUDUSDWeekly', lower_low_close_inside_l, 'lower_low_close_inside')


quotes.each_cons(6) do |first, second, third, fourth, fifth, sixth|
  @higher_high_close_above.process_and_write(first, second)
  @higher_high_close_inside.process_and_write(first, second)
  @lower_low_close_above.process_and_write(first, second)
  @lower_low_close_inside.process_and_write(first, second)
end

puts 'done'
