require 'json'

file = File.read('EURGBP.json')
data_hash = JSON.parse(file)
query = data_hash['query']
results = query['results']

#If today is down day what are the odds the next day is a down day?
down_day_counter = 0
next_day_down_counter = 0

def isADownDay(quote)
  quote['Close'] < quote['Open']
end

results['quote'].each_cons(2) do |first, second|
  if isADownDay(first)
    down_day_counter +=1
    if isADownDay(second)
      next_day_down_counter +=1
    end
  end
  puts "a #{first['Open']} b #{second['Open']}"
end


today_down_tomorrow_down = (next_day_down_counter.to_f / down_day_counter * 100).ceil

puts "#{today_down_tomorrow_down}%"