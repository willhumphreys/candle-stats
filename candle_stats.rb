require 'json'
require_relative 'candle_operations'
require_relative 'quote_counter'
require_relative 'down_days'
require_relative 'nearest_take_out'

file = File.read('EURGBP.json')
data_hash = JSON.parse(file)
quotes = data_hash['results']





$candle_operations = CandleOperations.new
$quote_counter = QuoteCounter.new
$nearest_take_out = NearestTakeOut.new

$down_days = DownDays.new

quotes.each_cons(2) do |first, second|
  $quote_counter.process(first,second)


  $down_days.process(first, second)
  $nearest_take_out.process(first, second)


end


$down_days.display

