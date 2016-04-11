require_relative 'candle_operations'

class HigherHighHigherLow
  def initialize
    @candle_operations = CandleOperations.new
  end

  #Candles go earliest first.
  def process(first, second, third, fourth, fifth, sixth)

    if @candle_operations.is_a_higher_high_in(first, second) && @candle_operations.is_a_lower_low_in(first, second)

      puts "hello"

    end

  end



  def display
  end

end
