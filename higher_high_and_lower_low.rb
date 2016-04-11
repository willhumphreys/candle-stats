require_relative 'candle_operations'

class HigherHighAndLowerLow


  def initialize
    @candle_operations = CandleOperations.new
    @first_second = 0
    @second_third = 0
    @third_fourth = 0
    @fourth_fifth = 0
    @fifth_sixth = 0

    @not_first_second = 0
    @not_second_third = 0
    @not_third_fourth = 0
    @not_fourth_fifth = 0
    @not_fifth_sixth = 0
  end

  #Candles go earliest first.
  def process(first, second, third, fourth, fifth, sixth)

    if @candle_operations.is_a_higher_high_in(first, second) && @candle_operations.is_a_lower_low_in(first, second)
      @first_second += 1

      if @candle_operations.is_a_higher_high_in(second, third) && @candle_operations.is_a_lower_low_in(second, third)
        @second_third += 1
        if @candle_operations.is_a_higher_high_in(third, fourth) && @candle_operations.is_a_lower_low_in(third, fourth)
          @third_fourth += 1
          if @candle_operations.is_a_higher_high_in(fourth, fifth) && @candle_operations.is_a_lower_low_in(fourth, fifth)
            @fourth_fifth += 1
            if @candle_operations.is_a_higher_high_in(fifth, sixth) && @candle_operations.is_a_lower_low_in(fifth, sixth)
              @fifth_sixth +=1
            else
              @not_fifth_sixth += 1
            end
          else
            @not_fourth_fifth += 1
          end
        else
         @not_third_fourth += 1
        end
      else
        @not_second_third += 1
      end
    else
      @not_first_second += 1
    end
  end

  def display
    puts "Higher high and lower low. 1-2: #{@first_second}/#{@not_first_second} "\
    "2-3: #{@second_third}/#{@not_second_third} 3-4: #{@third_fourth}/#{@not_third_fourth} "\
    "4-5: #{@fourth_fifth}/#{@not_fourth_fifth} 5-6: #{@fifth_sixth}/#{@not_fifth_sixth}"
  end

end
