require 'json'

file = File.read('EURGBP.json')
data_hash = JSON.parse(file)
quotes = data_hash['query']['results']['quote']

down_day_counter = 0
next_day_down_counter = 0

def is_a_down_day(quote)
  quote['Close'] < quote['Open']
end

quotes.each_cons(2) do |first, second|
  if is_a_down_day(first)
    down_day_counter +=1
    if is_a_down_day(second)
      next_day_down_counter +=1
    end
  end
  puts "a #{first['Open']} b #{second['Open']}"
end


#If today is down day what are the odds the next day is a down day?
today_down_tomorrow_down = (next_day_down_counter.to_f / down_day_counter * 100).ceil

puts "#{today_down_tomorrow_down}%"