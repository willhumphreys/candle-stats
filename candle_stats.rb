require 'json'
require_relative 'quote_counter'
require_relative 'down_days'
require_relative 'up_days'
require_relative 'nearest_take_out'
require_relative 'do_full_candle_gaps_close'
require_relative 'candle_gaps_close'
require_relative 'days_close_same_direction'
require_relative 'take_out_wrong_end'
require_relative 'higher_high_and_lower_low'
require_relative 'higher_high_and_higher_low'
require_relative 'lower_high_and_lower_low'
require_relative 'inside_day_and_inside_day'

require_relative 'bar_chart_file_repo'
require_relative 'mt4_file_repo'

require_relative 'take_outs'

@bar_chart_file_repo = BarChartFileRepo.new
@mt4_file_repo = MT4FileRepo.new
#quotes =  @bar_chart_file_repo.read_quotes
quotes = @mt4_file_repo.read_quotes

@quote_counter = QuoteCounter.new
@nearest_take_out = NearestTakeOut.new
@down_days = DownDays.new
@up_days = UpDays.new
@do_full_gaps_close = DoFullCandleGapsClose.new
@candle_gaps_close_4 = CandleGapsClose.new(0.0001)
@candle_gaps_close_5 = CandleGapsClose.new(0.00001)
@days_close_same_direction = DaysCloseSameDirection.new
@take_out_wrong_end = TakeOutWrongEnd.new
@higher_high_lower_low = HigherHighAndLowerLow.new
@higher_high_higher_low = HigherHighAndHigherLow.new
@lower_high_lower_low = LowerHighAndLowerLow.new
@inside_day_and_inside_day = InsideDayAndInsideDay.new

@take_outs = TakeOuts.new

quotes.each_cons(6) do |first, second, third, fourth, fifth, sixth|
  # @quote_counter.process(first,second)
  # @down_days.process(first, second)
  # @up_days.process(first, second)
  # @nearest_take_out.process(first, second)
  # @do_full_gaps_close.process(first, second)
  # @candle_gaps_close_4.process(first, second)
  # @candle_gaps_close_5.process(first, second)
  # @days_close_same_direction.process(first, second, third, fourth, fifth, sixth)
  # @take_out_wrong_end.process(first, second, third)
  # @higher_high_lower_low.process(first, second, third, fourth, fifth, sixth)
  # @higher_high_higher_low.process(first, second, third, fourth, fifth, sixth)
  # @lower_high_lower_low.process(first, second, third, fourth, fifth, sixth)
  # @inside_day_and_inside_day.process(first, second, third, fourth, fifth, sixth)

  @take_outs.process(first, second)



end

# puts '-- Up and down days --'
# @down_days.display
# @up_days.display
# @nearest_take_out.display(@quote_counter.count)
#
# puts "\n-- Gaps --"
# @do_full_gaps_close.display
# @candle_gaps_close_4.display
# @candle_gaps_close_5.display
# @days_close_same_direction.display
# @take_out_wrong_end.display
# puts "\n-- Highers and Lowers"
# @higher_high_lower_low.display
# @higher_high_higher_low.display
# @lower_high_lower_low.display
# @inside_day_and_inside_day.display

@take_outs.display
