require_relative 'candle_operations'

class NearestTakeOut

  def initialize
    @candle_ops = CandleOperations.new
    @next_day_opens_in_range_count = 0

    @candle_count = 0
    @take_out_low = 0
    @no_low_take_out = 0
    @take_out_high = 0
    @no_high_take_out = 0

    @wanted_low_got_high = 0
    @wanted_high_got_low = 0

    @inside_day_count = 0
    @inside_day_low_nearer_count = 0
    @inside_day_high_nearer_count = 0

    @both_days_up_low_nearer_high_taken = 0
    @both_days_up_low_nearer_low_taken = 0

    @both_days_down_high_nearer_low_taken = 0
    @both_days_down_high_nearer_high_taken = 0


    @low_nearer_take_up_high = 0

    @first_day_up = 0
    @both_days_up = 0

  end

  def process(first, second)

    @candle_count += 1

    if @candle_ops.is_day_up(first)
      @first_day_up += 1
    end

    if @candle_ops.is_day_up(first) && @candle_ops.is_day_up(second)
      @both_days_up += 1
    end

    #First trade closes up
    #Second trade opens nearer the the first high.
    #Second trade has a low that is nearer to the first high
    if @candle_ops.is_day_up(first) && @candle_ops.is_high_nearer(first, second) && is_low_nearer_to_previous_high(first, second)
      if @candle_ops.is_day_up(second)
        @both_days_up_low_nearer_high_taken += 1
      end

      if @candle_ops.is_a_higher_high_in(first, second) && @candle_ops.is_day_up(second)
        @low_nearer_take_up_high += 1
      end

      if @candle_ops.is_day_down(second)
        @both_days_up_low_nearer_low_taken += 1
      end
    end

    #First trade closes down
    #Second trade has a low nearer to the low of the first trade.
    #Second trade has a high that is nearer to the first low
    if @candle_ops.is_day_down(first) && @candle_ops.is_a_low_nearer(first, second) && is_high_nearer_to_previous_low(first, second)



      if @candle_ops.is_day_down(second)
        @both_days_down_high_nearer_low_taken += 1
      end

      if @candle_ops.is_day_up(second)
        @both_days_down_high_nearer_high_taken += 1
      end
    end

    if @candle_ops.is_day_opening_in_range(first, second)
      @next_day_opens_in_range_count += 1

      if @candle_ops.is_inside_day(first, second)
        @inside_day_count += 1
      end

      if @candle_ops.is_a_low_nearer(first, second)


        if @candle_ops.is_inside_day(first, second)
          @inside_day_low_nearer_count += 1
        end

        if @candle_ops.is_a_lower_low_in(first, second)
          @take_out_low += 1
        else
          @no_low_take_out +=1
          if @candle_ops.is_a_higher_high_in(first, second)
            @wanted_low_got_high += 1
          end
        end

      else
        if @candle_ops.is_high_nearer(first, second)

          if @candle_ops.is_inside_day(first, second)
            @inside_day_high_nearer_count += 1
          end

          if @candle_ops.is_a_higher_high_in(first, second)
            @take_out_high += 1
          else
            @no_high_take_out += 1
            if @candle_ops.is_a_lower_low_in(first, second)
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

  #Is the second low closer to the first high or the first low.
  def is_low_nearer_to_previous_high(first, second)
    (second.low - first.high).abs < (second.low - first.low).abs
  end


  #Is the second high closer to the first low or the first high.
  def is_high_nearer_to_previous_low(first, second)
    (second.high - first.low).abs < (second.high - first.high).abs
  end

  def display(quote_counter_count)
    puts "\n-- What do we take out --"
    #Does today open inside the range of the previous day
    next_day_opens_in_range = (@next_day_opens_in_range_count.to_f / quote_counter_count * 100).ceil
    puts "Next day opens in range: #{next_day_opens_in_range}% (#{@next_day_opens_in_range_count})"

    puts "Low taken out when nearest #{get_take_out_low_p }%. Take out count #{@take_out_low} times. "\
    "Low not taken out #{@no_low_take_out} times. Inside candle #{@inside_day_low_nearer_count} "\
    "#{(@take_out_low.to_f / @no_low_take_out).round(2)}% #{((@inside_day_count.to_f / @candle_count)* 100.round(2)).ceil}%"

    puts "Wanted high go low #{((@wanted_high_got_low.to_f / (@take_out_low + @take_out_high)) * 100).ceil}%"

    puts "High taken out when nearest #{get_take_out_high_p}%. Take out count #{@take_out_high} times. "\
    "High not taken out #{@no_high_take_out} times. Inside candle #{@inside_day_high_nearer_count} "\
    "#{(@take_out_high.to_f / @no_high_take_out).round(2)}%"

    puts "Wanted low got high #{((@wanted_low_got_high.to_f / (@take_out_low + @take_out_high)) * 100).ceil}%"

    puts "\n--- First day up. Second day opens and puts in a low that is still nearer to the previous days high. ---"
    puts "First Day Closes up. #{@first_day_up}"
    puts "Both days close up. #{@both_days_up}"
    puts "First Day Closes up Second day up. #{@both_days_up_low_nearer_high_taken}"
    puts "First Day Closes up. Second day takes out high #{@low_nearer_take_up_high}"
    puts "First Day Closes up. Second day down. #{@both_days_up_low_nearer_low_taken}"

    puts "\n--- First day down. Second day opens and puts in a high that is still nearer to the previous days low. ---"
    puts "First Day Closes down. Second day down. #{@both_days_down_high_nearer_low_taken}"
    puts "First Day Closes. Second day up. #{@both_days_down_high_nearer_high_taken}\n\n"
  end

  def get_take_out_high_p
    ((@take_out_high.to_f/ (@take_out_high + @no_high_take_out)) * 100).ceil
  end

  def get_take_out_low_p
    ((@take_out_low.to_f / (@take_out_low + @no_low_take_out)) * 100).ceil
  end
end
