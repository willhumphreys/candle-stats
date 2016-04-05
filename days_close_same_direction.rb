class DaysCloseSameDirection

  def initialize
    @tick_count = 0

    @day_up_count = 0
    @day_up_count_2 = 0
    @day_not_up_count_2 = 0
    @day_up_count_3 = 0
    @day_not_up_count_3 = 0
    @day_up_count_4 = 0
    @day_not_up_count_4 = 0
    @day_up_count_5 = 0
    @day_not_up_count_5 = 0
    @day_up_count_6 = 0
    @day_not_up_count_6 = 0

    @day_down_count = 0
    @day_down_count_2 = 0
    @day_not_down_count_2 = 0
    @day_down_count_3 = 0
    @day_not_down_count_3 = 0
    @day_down_count_4 = 0
    @day_not_down_count_4 = 0
    @day_down_count_5 = 0
    @day_not_down_count_5 = 0
    @day_down_count_6 = 0
    @day_not_down_count_6 = 0

    @day_up_down_2 = 0
    @day_up_down_3 = 0
    @day_up_down_4 = 0
    @day_up_down_5 = 0
    @day_up_down_6 = 0
  end

  def is_day_up(quote)
    quote['close'] > quote['open']
  end

  def is_day_down(quote)
    quote['close'] < quote['open']
  end

  def day_percentage(day_up_count, day_not_up_count)
    ((day_up_count.to_f / (day_not_up_count + day_up_count)) * 100).round(2)
  end

  def process(first, second, third, fourth, fifth, sixth)

    @tick_count += 1

    if is_day_up(first)
      @day_up_count += 1
    else
      @day_down_count +=1
    end

    if is_day_up(first) && is_day_up(second)
      @day_up_count_2 += 1
    else
      @day_not_up_count_2 += 1
    end

    if is_day_up(first) && is_day_down(second)
      @day_up_down_2 += 1
    end


    if is_day_up(first) && is_day_up(second) && is_day_up(third)
      @day_up_count_3 += 1
    else
      @day_not_up_count_3 += 1
    end

    if is_day_up(first) && is_day_up(second) && is_day_down(third)
      @day_up_down_3 += 1
    end

    if is_day_up(first) && is_day_up(second) && is_day_up(third) && is_day_up(fourth)
      @day_up_count_4 += 1
    else
      @day_not_up_count_4 += 1
    end

    if is_day_up(first) && is_day_up(second) && is_day_up(third) && is_day_down(fourth)
      @day_up_down_4 += 1
    end

    if is_day_up(first) && is_day_up(second) && is_day_up(third) && is_day_up(fourth) && is_day_up(fifth)
      @day_up_count_5 += 1
    else
      @day_not_up_count_5 += 1
    end

    if is_day_up(first) && is_day_up(second) && is_day_up(third) && is_day_up(fourth) && is_day_down(fifth)
      @day_up_down_5 += 1
    end

    if is_day_up(first) && is_day_up(second) && is_day_up(third) && is_day_up(fourth) && is_day_up(fifth) && is_day_up(sixth)
      @day_up_count_6 += 1
    else
      @day_not_up_count_6 += 1
    end

    if is_day_up(first) && is_day_up(second) && is_day_up(third) && is_day_up(fourth) && is_day_up(fifth) && is_day_down(sixth)
      @day_up_down_6 += 1
    end


    if is_day_down(first) && is_day_down(second)
      @day_down_count_2 += 1
    else
      @day_not_down_count_2 += 1
    end

    if is_day_down(first) && is_day_down(second) && is_day_down(third)
      @day_down_count_3 += 1
    else
      @day_not_down_count_3 += 1
    end

    if is_day_down(first) && is_day_down(second) && is_day_down(third) && is_day_down(fourth)
      @day_down_count_4 += 1
    else
      @day_not_down_count_4 += 1
    end

    if is_day_down(first) && is_day_down(second) && is_day_down(third) && is_day_down(fourth) && is_day_down(fifth)
      @day_down_count_5 += 1
    else
      @day_not_down_count_5 += 1
    end

    if is_day_down(first) && is_day_down(second) && is_day_down(third) && is_day_down(fourth) && is_day_down(fifth) && is_day_down(sixth)
      @day_down_count_6 += 1
    else
      @day_not_down_count_6 += 1
    end

  end


  def display
    puts "\n-- Candles in a row --"
    puts "Tick count #{@tick_count} Up count #{@day_up_count} 2 Days up #{@day_up_count_2} #{day_percentage(@day_up_count_2, @day_not_up_count_2)}%. "\
    "3 Days up  #{@day_up_count_3} #{day_percentage(@day_up_count_3, @day_not_up_count_3)}%. "\
    "4 Days up #{@day_up_count_4} #{day_percentage(@day_up_count_4, @day_not_up_count_4)}%. "\
    "5 Days up #{@day_up_count_5} #{day_percentage(@day_up_count_5, @day_not_up_count_5)}%. "\
    "6 Days up #{@day_up_count_6} #{day_percentage(@day_up_count_6, @day_not_up_count_6)}%. "


    puts "Tick count #{@tick_count} Down count #{@day_down_count} 2 Days down #{@day_down_count_2} #{day_percentage(@day_down_count_2, @day_not_down_count_2)}%. "\
    "3 Days down  #{@day_down_count_3} #{day_percentage(@day_down_count_3, @day_not_down_count_3)}%. "\
    "4 Days down #{@day_down_count_4} #{day_percentage(@day_down_count_4, @day_not_down_count_4)}%. "\
    "5 Days down #{@day_down_count_5} #{day_percentage(@day_down_count_5, @day_not_down_count_5)}%. "\
    "6 Days down #{@day_down_count_6} #{day_percentage(@day_down_count_6, @day_not_down_count_6)}%. "

    puts "\n--- What are the odds on having another up day after you have already had a few ----"
    puts "2 Days up: #{@day_up_count_2} Last Down: #{@day_up_down_2} #{day_percentage(@day_up_count_2, @day_up_down_2)}%  #{day_percentage(@day_up_down_2, @day_up_count_2)}%"
    puts "3 Days up: #{@day_up_count_3} Last Down: #{@day_up_down_3} #{day_percentage(@day_up_count_3, @day_up_down_3)}% #{day_percentage(@day_up_down_3, @day_up_count_3)}%"
    puts "4 Days up: #{@day_up_count_4} Last Down: #{@day_up_down_4} #{day_percentage(@day_up_count_4, @day_up_down_4)}% #{day_percentage(@day_up_down_4, @day_up_count_4)}%"
    puts "5 Days up: #{@day_up_count_5}  Last Down: #{@day_up_down_5}  #{day_percentage(@day_up_count_5, @day_up_down_5)}% #{day_percentage(@day_up_down_5, @day_up_count_5)}%"
    puts "6 Days up: #{@day_up_count_6}  Last Down: #{@day_up_down_6}  #{day_percentage(@day_up_count_6, @day_up_down_6)}% #{day_percentage(@day_up_down_6, @day_up_count_6)}%"
  end
end
