require_relative 'candle_operations'
require 'fileutils'

class HighTakeOutAndHold

  def initialize(contract)
    @candle_ops = CandleOperations.new

    @candle_count = 0
    @high_closes_above_range = 0
    @high_total_close_above = 0
    @higher_high_count = 0

    FileUtils.mkdir_p 'out'

    @higher_high_close_above_f = "out/#{contract}_higher_high_close_above.csv"

    open(@higher_high_close_above_f, 'a') do |f|
      f.puts 'date.time, pips'
    end

  end

  def process(first, second)
    @candle_count += 1

    if @candle_ops.is_a_higher_high_in(first, second)
      @higher_high_count += 1
      if @candle_ops.closes_above_range(first, second)
        high_diff = ((second.high - first.high) * 10000).round(0)
        open(@higher_high_close_above_f, 'a') do |f|
          f.puts "#{second.timestamp}, #{high_diff}"
        end
        @high_total_close_above += high_diff
        @high_closes_above_range += 1
      end
    end
  end

  def display
    puts '----- If we take out the high'
    puts "High taken out. What to close above. Average pips #{@high_total_close_above  / @high_closes_above_range}"
    @candle_ops.percent_message(@high_closes_above_range, @higher_high_count, 'We close above the previous range')
  end

end