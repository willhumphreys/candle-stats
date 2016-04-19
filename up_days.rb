require_relative 'candle_operations'

class UpDays
  def initialize
    @candle_operations = CandleOperations.new
    @first_tick_count = 0
    @both_ticks_count = 0
    @higher_high_in = 0
    @first_day_up_second_day_down = 0
    @second_candle_closes_above_close = 0
    @second_candle_closes_below_close = 0
  end

  def process(first, second)
    if @candle_operations.is_a_up_day(first)
      @first_tick_count +=1

      if second.open < first.close
        if(second.close > first.close)
          @second_candle_closes_above_close += 1
        else
          @second_candle_closes_below_close += 1
        end
      end

      if @candle_operations.is_a_up_day(second)
        @both_ticks_count +=1
      else
        if @candle_operations.is_a_down_day(second)
          @first_day_up_second_day_down +=1
        end
      end
      if @candle_operations.is_a_higher_high_in(first, second)
        @higher_high_in += 1
      end
    end
  end

  def get_both_ticks_count
    @both_ticks_count
  end

  def get_first_tick_count
    @first_tick_count
  end

  def display
    puts "If today is up what are the odds tomorrow is up to: #{get_sequential_percentage(@both_ticks_count, @first_tick_count)}%"
    puts "If today is positive what are the odds tomorrow closes positive: #{get_sequential_percentage(@second_candle_closes_above_close, @second_candle_closes_below_close + @second_candle_closes_above_close)}%"
    puts "If today is positive what are the odds the next candle takes out its high #{get_sequential_percentage(@higher_high_in, @first_tick_count )}%"
  end

  def get_sequential_percentage(both_ticks_count, first_tick_count)
    (both_ticks_count.to_f / first_tick_count * 100).ceil
  end
end
