require_relative 'candle_operations'

class NearestTakeOut

  def initialize
    @candle_operations = CandleOperations.new
    @next_day_opens_in_range_count = 0

    @take_out_low = 0
    @no_low_take_out = 0
    @take_out_high = 0
    @no_high_take_out = 0

    @wanted_low_got_high = 0
    @wanted_high_got_low = 0

  end

  def process(first, second)


    if @candle_operations.is_day_opening_in_range(first, second)
      @next_day_opens_in_range_count += 1

      if @candle_operations.is_a_low_nearer(first, second)

        if @candle_operations.is_a_lower_low_in(first, second)
          @take_out_low += 1
        else
          @no_low_take_out +=1
          if @candle_operations.is_a_higher_high_in(first, second)
            @wanted_low_got_high += 1
          end
        end

      else
        if @candle_operations.is_high_nearer(first, second)

          if @candle_operations.is_a_higher_high_in(first, second)
            @take_out_high += 1
          else
            @no_high_take_out += 1
            if @candle_operations.is_a_lower_low_in(first, second)
              @wanted_high_got_low += 1
            end
          end

        end

      end

    else
      # puts 'This shouldn\'t happen often'
    end

  end

  def get_next_day_opens_range_count
    @next_day_opens_in_range_count
  end

  def get_take_out_low_count
    @take_out_low
  end

  def get_take_out_high_count
    @take_out_high
  end

  def get_wanted_low_got_high
    @wanted_low_got_high
  end

  def get_wanted_high_got_low
    @wanted_high_got_low
  end

  def get_no_high_take_out
    @no_high_take_out
  end

  def get_no_low_take_out
    @no_low_take_out
  end

  def display(quote_counter_count)
    #Does today open inside the range of the previous day
    next_day_opens_in_range = (@next_day_opens_in_range_count.to_f / quote_counter_count * 100).ceil
    puts "Next day opens in range: #{next_day_opens_in_range}% (#{@next_day_opens_in_range_count})"

    puts "Low taken out when nearest #{((@take_out_low.to_f / (@take_out_low + @no_low_take_out)) * 100).ceil }%. "\
    "Take out count #{@take_out_low} times. Low not taken out #{@no_low_take_out} times. "\
    "#{(@take_out_low.to_f / @no_low_take_out).round(2)}"
    puts "Wanted high go low #{((@wanted_high_got_low.to_f / (@take_out_low + @take_out_high)) * 100).ceil}%"
    puts "High taken out when nearest #{((@take_out_high.to_f/ (@take_out_high + @no_high_take_out)) * 100).ceil}%. "\
    "Take out count #{@take_out_high} times. High not taken out #{@no_high_take_out} times. "\
    "#{(@take_out_high.to_f / @no_high_take_out).round(2)}"
    puts "Wanted low got high #{((@wanted_low_got_high.to_f / (@take_out_low + @take_out_high)) * 100).ceil}%"

  end
end
