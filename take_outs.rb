require_relative 'candle_operations'
require 'fileutils'

class TakeOuts

  def initialize
    @candle_ops = CandleOperations.new

    @higher_high_count = 0
    @lower_low_count = 0
    @candle_count = 0
    @high_and_low_taken_out = 0
    @inside_range_count = 0

    @higher_high_closes_in_range = 0
    @higher_high_closes_above_range = 0
    @higher_high_closes_below_range = 0

    @distance_above_high_count = 0

    @lower_low_closes_in_range = 0
    @lower_low_closes_above_range = 0
    @lower_low_closes_below_range = 0


    FileUtils.rm_rf('out')
    FileUtils.mkdir_p 'out'

    @higher_high_close_in_range_f = 'out/higher_high_close_in_range.csv'
    @higher_high_close_above_f = 'out/higher_high_close_above.csv'

    open(@higher_high_close_in_range_f, 'a') do |f|
      f.puts 'date.time, pips'
    end

    open(@higher_high_close_above_f, 'a') do |f|
      f.puts 'date.time, pips'
    end

  end

  def process(first, second)
    @candle_count += 1

    if @candle_ops.is_a_higher_high_in(first, second)
      @higher_high_count += 1
    end

    if @candle_ops.is_a_lower_low_in(first, second)
      @lower_low_count += 1
    end

    if @candle_ops.is_a_lower_low_in(first, second) && @candle_ops.is_a_higher_high_in(first, second)
      @high_and_low_taken_out += 1
    end

    if @candle_ops.is_inside_day(first, second)
      @inside_range_count += 1
    end

    if @candle_ops.is_a_higher_high_in(first, second)

      if @candle_ops.closes_inside_range(first, second)
        distance_above_high_close_inside = ((second.high - first.high) * 10000).round(0)
        open(@higher_high_close_in_range_f, 'a') do |f|
          f.puts "#{second.timestamp}, #{distance_above_high_close_inside}"
        end
        @distance_above_high_count += distance_above_high_close_inside
        @higher_high_closes_in_range += 1
      end

      if @candle_ops.closes_above_range(first, second)
        distance_above_high_close_above = ((second.high - first.high) * 10000).round(0)
        open(@higher_high_close_above_f, 'a') do |f|
          f.puts distance_above_high_close_above
        end
        @distance_above_high_count += distance_above_high_close_above
        @higher_high_closes_above_range += 1
      end

      if @candle_ops.closes_below_range(first, second)
        @higher_high_closes_below_range += 1
      end

    end

    if @candle_ops.is_a_lower_low_in(first, second)

      if @candle_ops.closes_inside_range(first, second)
        @lower_low_closes_in_range += 1
      end

      if @candle_ops.closes_below_range(first, second)
        @lower_low_closes_below_range += 1
      end

      if @candle_ops.closes_above_range(first, second)
        @lower_low_closes_above_range += 1
      end

    end

  end

  def display

    @candle_ops.percent_message(@higher_high_count, @candle_count, 'Take out high')
    @candle_ops.percent_message(@lower_low_count, @candle_count, 'Take out low')
    @candle_ops.percent_message(@high_and_low_taken_out, @candle_count, 'Take out high and low')
    @candle_ops.percent_message(@inside_range_count, @candle_count, 'Stay inside range')
    puts '----- If we take out the high'
    @candle_ops.percent_message(@higher_high_closes_in_range, @higher_high_count,
                                'We close back in the range')
    puts "On average we go #{av_distance_above_range} pips above the range before reversing and closing back inside the range"
    @candle_ops.percent_message(@higher_high_closes_above_range, @higher_high_count,
                                'We close above the previous range')
    @candle_ops.percent_message(@higher_high_closes_below_range, @higher_high_count,
                                'We close below the previous range')
    puts '---- If we take out the low'
    @candle_ops.percent_message(@lower_low_closes_in_range, @lower_low_count,
                                'We close back in the range')
    @candle_ops.percent_message(@lower_low_closes_below_range, @lower_low_count,
                                'We close below the previous range')
    @candle_ops.percent_message(@lower_low_closes_above_range, @lower_low_count,
                                'We close above the previous range')

  end

  def av_distance_above_range
    @distance_above_high_count / @higher_high_closes_in_range
  end
end