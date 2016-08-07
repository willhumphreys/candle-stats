require 'json'
require_relative 'bar_chart_file_repo'
require_relative 'mt4_file_repo'
require_relative 'consecutive_stat_executor'
require_relative 'candle_operations'
require_relative 'processor'
require_relative 'consecutive_profit_processors'
require_relative 'news_reader'
require_relative 'back_test_mapper'

@bar_chart_file_repo = BarChartFileRepo.new
@mt4_file_repo = MT4FileRepo.new(BackTestMapper.new)
@candle_ops = CandleOperations.new
@processors = Consecutive_Profit_Processors.new

time_periods = %w(10y)
symbols = %w(audusd eurchf eurgbp eurusd gbpusd nzdusd usdcad usdchf)

data_sets = symbols.product(time_periods).collect { |time_period, symbol| time_period + '_breakout_' +symbol }

data_sets.each { |data_set|
  quotes = @mt4_file_repo.read_quotes("breakout_results/#{data_set}.csv")

  executors = @processors.processors.values.collect { |processor| Stat_Executor.new(data_set, processor) }

  quotes.each_cons(6) do |first, second, third, fourth, fifth, sixth|

    executors.each { |executor|
      executor.process_and_write(first, second)
    }

  end

  @processors.reset


}

puts 'done'