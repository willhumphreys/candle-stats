require_relative 'candle_operations'
class Consecutive_Profit_Processors
  attr_reader :processors

  def initialize
    @candle_ops = CandleOperations.new
    @two_consecutive_wins_count = 0
    @first_tick_wins = 0

    winner_next_one_winner_l = lambda do |first, second|
      if first.ticks >0
        @first_tick_wins += 1
        if second.ticks > 0
          @two_consecutive_wins_count += 1
        end
      end
      @two_consecutive_wins_count.to_f / @first_tick_wins

    end

    # higher_high_close_inside_l = lambda do |first, second, contract|
    #   if @candle_ops.is_a_higher_high_in(first, second) && @candle_ops.closes_inside_range(first, second)
    #     return @candle_ops.get_pip_difference(first.high, second.high, contract)
    #   end
    #   nil
    # end
    #
    # lower_low_close_below_l = lambda do |first, second, contract|
    #   if @candle_ops.is_a_lower_low_in(first, second) && @candle_ops.closes_below_range(first, second)
    #     return @candle_ops.get_pip_difference(first.low, second.low, contract)
    #   end
    #   return nil
    # end
    #
    # lower_low_close_inside_l = lambda do |first, second, contract|
    #   if @candle_ops.is_a_lower_low_in(first, second) && @candle_ops.closes_inside_range(first, second)
    #     return @candle_ops.get_pip_difference(first.low, second.low, contract)
    #   end
    #   nil
    # end

    @processors = {
        :higher_high_close_above => Processor.new('one_trade_wins_odds_next_trade_wins', winner_next_one_winner_l),
        # :higher_high_close_inside => Processor.new('higher_high_close_inside', higher_high_close_inside_l),
        # :lower_low_close_below => Processor.new('lower_low_close_below', lower_low_close_below_l),
        # :lower_low_close_inside => Processor.new('lower_low_close_inside', lower_low_close_inside_l)
    }
  end

end