require 'json'
require_relative 'bar_chart_file_repo'
require_relative 'mt4_file_repo'
require_relative 'stat_executor'
require_relative 'candle_operations'
require_relative 'processor'
require_relative 'processors'
require_relative 'news_reader'
require_relative 'fade_mapper'
require 'active_support/all'

@bar_chart_file_repo = BarChartFileRepo.new
@mt4_file_repo = MT4FileRepo.new(FadeMapper.new)
@candle_ops = CandleOperations.new
@processors = Processors.new

FileUtils.rm_rf Dir.glob('results_could_of_been_better/*')


time_periods = %w(_FadeTheBreakoutNormalDaily)
#time_periods = %w(_NormalDaily10y)
#time_periods = %w(_FadeTheBreakoutNormal_10y)

symbols = %w(audusd eurchf eurgbp eurusd gbpusd usdcad usdchf nzdusd usdjpy eurjpy)

data_sets = symbols.product(time_periods).collect { |time_period, symbol| time_period + symbol }

data_sets.each { |data_set|
  profits = @mt4_file_repo.read_quotes("backtesting_data/#{data_set}.csv")



  profits.each_cons(6) do |first, second, third, fourth, fifth, sixth|

    puts first

  end
}
