require 'json'
require_relative 'quote_counter'
require_relative 'down_days'
require_relative 'up_days'
require_relative 'nearest_take_out'
require_relative 'do_gaps_close'

file = File.read('EURGBP.json')
data_hash = JSON.parse(file)
quotes = data_hash['results']

@quote_counter = QuoteCounter.new
@nearest_take_out = NearestTakeOut.new
@down_days = DownDays.new
@up_days = UpDays.new
@do_gaps_close = DoGapsClose.new

quotes.each_cons(2) do |first, second|
  @quote_counter.process(first,second)
  @down_days.process(first, second)
  @up_days.process(first, second)
  @nearest_take_out.process(first, second)
  @do_gaps_close.process(first, second)
end

@down_days.display
@up_days.display
@nearest_take_out.display(@quote_counter.count)

@do_gaps_close.display()