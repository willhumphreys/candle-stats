require 'json'
require_relative 'down_day'
require_relative 'candle_operations'
require_relative 'quote_counter'

file = File.read('EURGBP.json')
data_hash = JSON.parse(file)
quotes = data_hash['results']

down_day_counter = 0
next_day_down_counter = 0

next_day_opens_in_range_count = 0

take_out_low = 0
no_low_take_out = 0
take_out_high = 0
no_high_take_out = 0

wanted_low_got_high = 0
wanted_high_got_low = 0

$down_day = DownDay.new
$candle_operations = CandleOperations.new
$quote_counter = QuoteCounter.new

quotes.each_cons(2) do |first, second|
  $quote_counter.process(first,second)

  if $down_day.is_a_down_day(first)
    down_day_counter +=1
    if $down_day.is_a_down_day(second)
      next_day_down_counter +=1
    end
  end

  if $candle_operations.is_day_opening_in_range(first, second)
    next_day_opens_in_range_count += 1

    if $candle_operations.is_a_low_nearer(first, second)

      if $candle_operations.is_a_lower_low_in(first, second)
        take_out_low += 1
      else
        no_low_take_out +=1
        if $candle_operations.is_a_higher_high_in(first, second)
          wanted_low_got_high += 1
        end
      end

    else
      if $candle_operations.is_high_nearer(first, second)

        if $candle_operations.is_a_higher_high_in(first, second)
          take_out_high += 1
        else
          no_high_take_out += 1
          if $candle_operations.is_a_lower_low_in(first, second)
            wanted_high_got_low += 1
          end
        end

      end

    end

  else
   # puts 'This shouldn\'t happen often'
  end

end


#If today is down day what are the odds the next day is a down day?
today_down_tomorrow_down = (next_day_down_counter.to_f / down_day_counter * 100).ceil
puts "If today is down what are the odds tomorrow is down to: #{today_down_tomorrow_down}%"

#Does today open inside the range of the previous day
next_day_opens_in_range = (next_day_opens_in_range_count.to_f / $quote_counter.count * 100).ceil
puts "Next day opens in range: #{next_day_opens_in_range}% (#{next_day_opens_in_range_count})"


puts "Low taken out when nearest #{((take_out_low.to_f / (take_out_low + no_low_take_out)) * 100).ceil }%. Take out count #{take_out_low} times. Low not take out #{no_low_take_out} times. #{(take_out_low.to_f / no_low_take_out).round(2)}"
puts "Wanted high go low #{((wanted_high_got_low.to_f / (take_out_low + take_out_high)) * 100).ceil}%"
puts "High taken out when nearest #{((take_out_high.to_f/ (take_out_high + no_high_take_out)) * 100).ceil}%. Take out count #{take_out_high} times. High not take out #{no_high_take_out} times. #{(take_out_high.to_f / no_high_take_out).round(2)}"
puts "Wanted low got high #{((wanted_low_got_high.to_f / (take_out_low + take_out_high)) * 100).ceil}%"
