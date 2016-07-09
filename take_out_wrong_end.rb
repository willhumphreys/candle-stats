require_relative 'candle_operations'

class TakeOutWrongEnd

  def initialize
    @candle_ops = CandleOperations.new

    @close_up = 0
    @close_down = 0

    @high_reverse_success = 0
    @high_reverse_fail = 0

  end


  def process(first, second, third)

    # If the first candle closes closer to its low.
    # The second candle reverses and closes above the high of the first candle.
    # What does the third candle do?

    #Doesn't take out the low of the first candle.....
    if @candle_ops.candle_closes_closer_low(first)
      if second.close > first.high && @candle_ops.is_a_up_day(second) && second.low > first.low
        if third.close > third.open
          @close_up += 1

        end

        if third.close < third.open
          @close_down -= 1
        end
      end
    end


    #Close near the high
    if @candle_ops.candle_closes_closer_high(first)
      #Next close is below the low of the first candle.
      if second.close < first.low && @candle_ops.is_a_down_day(second) && second.high < first.high

        #Third candle is down.
        if third.close < third.open
          @high_reverse_success += 1

        end

        if third.close > third.open
          @high_reverse_fail += 1

        end
      end
    end
  end

  def display

    puts "\n--- First candle closes closer to its low. Second candle reverses and takes out high of the first candle."\
  'What does the third candle do? ---'

    puts "Close up #{@close_up}. Close down #{@close_down}\n"

    puts "\n--- First candle closes closer to its high. Second candle reverses and takes out low of the first candle."\
  'What does the third candle do? ---'

    puts "Reverse success #{@high_reverse_success}. Reverse fail #{@high_reverse_fail}\n"

  end


end
