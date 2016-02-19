require 'json'

file = File.read('EURGBP.json')
data_hash = JSON.parse(file)
quotes = data_hash['results']

quote_count = 0
down_day_counter = 0
next_day_down_counter = 0

next_day_opens_in_range_count = 0

def is_a_down_day(quote)
  quote['close'] < quote['open']
end

quotes.each_cons(2) do |first, second|
  quote_count += 1

  if is_a_down_day(first)
    down_day_counter +=1
    if is_a_down_day(second)
      next_day_down_counter +=1
    end
  end

  if second['open'] >= first['low'] && second['open'] <= first['high']
    next_day_opens_in_range_count += 1
  else
    puts 'This shouldn\'t happen often'
  end

end


#If today is down day what are the odds the next day is a down day?
today_down_tomorrow_down = (next_day_down_counter.to_f / down_day_counter * 100).ceil
puts "If today is down what are the odds tomorrow is down to: #{today_down_tomorrow_down}%"

#Does today open inside the range of the previous day
next_day_opens_in_range = (next_day_opens_in_range_count.to_f / quote_count * 100).ceil
puts "Next day opens in range: #{next_day_opens_in_range}% (#{next_day_opens_in_range_count})"
