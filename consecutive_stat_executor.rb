require_relative 'candle_operations'
require_relative 'processor'
require 'fileutils'

class Stat_Executor

  def initialize(contract, processor)
    @candle_ops = CandleOperations.new
    @processor = processor
    @contract = contract

    FileUtils.mkdir_p 'out'

    @out_csv_file = "consecutive_out/#{contract}_#{@processor.name}.csv"

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

  def process_and_write(first, second, third, fourth)
    result = @processor.processor_function.call(first, second, third, fourth)
    if result != nil
      write((result * 100).round(2), second.date)
    end
  end

  def write(high_diff, timestamp)
    open(@out_csv_file, 'a') do |f|
      f.puts "#{timestamp}, #{high_diff}"
    end
  end
end