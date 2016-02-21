require_relative 'candle_operations'

class DownDays
  def initialize
    @candle_operations = CandleOperations.new
    @down_day_counter = 0
    @sequential_down_day_counter = 0
  end

  def process(first, second)
    if @candle_operations.is_a_down_day(first)
      @down_day_counter +=1
      if @candle_operations.is_a_down_day(second)
        @sequential_down_day_counter +=1
      end
    end
  end

  def count
    @sequential_down_day_counter
  end

  def display
    #If today is down day what are the odds the next day is a down day?
    today_down_tomorrow_down = (@sequential_down_day_counter.to_f / @down_day_counter * 100).ceil
    puts "If today is down what are the odds tomorrow is down to: #{today_down_tomorrow_down}%"
  end

end
