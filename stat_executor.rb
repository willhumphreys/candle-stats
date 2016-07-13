require_relative 'candle_operations'
require 'fileutils'

class Stat_Executor

  def initialize(contract, l, stat_name)
    @candle_ops = CandleOperations.new
    @lambda = l

    FileUtils.mkdir_p 'out'

    @out_csv_file = "out/#{contract}_#{stat_name}.csv"

    if File.exist?(@out_csv_file)
      File.truncate(@out_csv_file, 0)
    end

    write_file_header
  end

  def write_file_header
    open(@out_csv_file, 'a') do |f|
      f.puts 'date.time, pips'
    end
  end

  def process(first, second)
    if @candle_ops.is_a_higher_high_in(first, second) && @candle_ops.closes_above_range(first, second)
      return ((second.high - first.high) * 10000).round(0)
    end
    nil
  end

  def process_and_write(first, second)
    result = @lambda.call(first, second)
    if result != nil
      write(result, second.timestamp)
    end
  end

  def write(high_diff, timestamp)
    open(@out_csv_file, 'a') do |f|
      f.puts "#{timestamp}, #{high_diff}"
    end
  end
end