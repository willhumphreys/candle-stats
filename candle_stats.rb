require 'json'
require_relative 'bar_chart_file_repo'
require_relative 'mt4_file_repo'
require_relative 'stat_executor'
require_relative 'candle_operations'
require_relative 'processor'
require_relative 'processors'

@bar_chart_file_repo = BarChartFileRepo.new
@mt4_file_repo = MT4FileRepo.new
@candle_ops = CandleOperations.new
@processors = Processors.new

time_periods = ['10080']
symbols = ['AUDUSD']

data_sets = symbols.product(time_periods).collect { |time_period, symbol| time_period + symbol }

data_sets.each { |data_set|
  quotes = @mt4_file_repo.read_quotes("data/#{data_set}.csv")

  executors = @processors.processors.values.collect { |processor| Stat_Executor.new(data_set, processor) }

  quotes.each_cons(6) do |first, second, third, fourth, fifth, sixth|

    executors.each { |executor|
      executor.process_and_write(first, second)
    }

  end
}

puts 'done'