require_relative 'candle_operations'
class Consecutive_Profit_Processors
  attr_reader :processors

  def initialize
    @candle_ops = CandleOperations.new
    @two_consecutive_wins_count = 0
    @first_tick_wins = 0
    @first_second_tick_wins = 0
    @three_consecutive_wins_count = 0

    winner_next_one_winner_l = lambda do |first, second, third|
      if first.ticks >0
        @first_tick_wins += 1
        if second.ticks > 0
          @two_consecutive_wins_count += 1
        end
      end
      @two_consecutive_wins_count.to_f / @first_tick_wins
    end

    two_winners_next_one_winner_l = lambda do |first, second, third|
      if first.ticks >0 && second.ticks > 0
        @first_second_tick_wins += 1
        if third.ticks > 0
          @three_consecutive_wins_count += 1
        end
      end
      @three_consecutive_wins_count.to_f / @first_second_tick_wins
    end


    def reset
      @two_consecutive_wins_count = 0
      @first_tick_wins = 0
      @first_second_tick_wins = 0
      @three_consecutive_wins_count = 0
    end

    @processors = {
        :higher_high_close_above => Processor.new('one_trade_wins_odds_next_trade_wins', winner_next_one_winner_l),
        :two_trades_win_odds_next_trade_wins => Processor.new('two_trades_win_odds_next_trade_wins', two_winners_next_one_winner_l),
        # :higher_high_close_inside => Processor.new('higher_high_close_inside', higher_high_close_inside_l),
        # :lower_low_close_below => Processor.new('lower_low_close_below', lower_low_close_below_l),
        # :lower_low_close_inside => Processor.new('lower_low_close_inside', lower_low_close_inside_l)
    }
  end

end