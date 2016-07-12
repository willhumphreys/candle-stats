require 'json'
require_relative 'bar_chart_file_repo'
require_relative 'mt4_file_repo'
require_relative 'higher_high_close_above'
require_relative 'higher_high_close_inside'

@bar_chart_file_repo = BarChartFileRepo.new
@mt4_file_repo = MT4FileRepo.new
quotes = @mt4_file_repo.read_quotes('data/AUDUSD10080.csv')

@higher_high_close_above = HigherHighCloseAbove.new('AUDUSDWeekly')
@higher_high_close_inside = HigherHighCloseInside.new('AUDUSDWeekly')

quotes.each_cons(6) do |first, second, third, fourth, fifth, sixth|
  @higher_high_close_above.process_and_write(first, second)
  @higher_high_close_inside.process_and_write(first, second)
end

puts 'done'
