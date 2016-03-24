require_relative 'candle_operations'

class TakeOutWrongEnd

  def initialize
    @candle_operations = CandleOperations.new

    @close_up = 0
    @close_down = 0

  end


  def process(first, second, third)

    # If the first candle closes closer to its low.
    # The second candle reverses and closes above the high of the first candle.
    # What does the third candle do?

    if @candle_operations.candle_closes_closer_low(first)
      if second.close > first.high && @candle_operations.is_a_up_day(second)
        if third.close > third.open
          @close_up += 1

        end

        if third.close < third.open
          @close_down -= 1
        end
      end
    end
  end

  def display

    puts "\n--- First candle closes closer to its low. Second candle reverses and takes out high of the first candle."\
  'What does the third candle do? ---'

    puts "Close up #{@close_up}. Close down #{@close_down}\n"

  end


end
