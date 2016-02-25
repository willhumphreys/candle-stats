class DaysCloseSameDirection

  def initialize
    @day_up_count_2 = 0
    @day_up_count_3 = 0
    @day_up_count_4 = 0
    @day_up_count_5 = 0
  end

  def process(first, second, third, fourth, fifth)

    if is_day_up(first) && is_day_up(second)
      @day_up_count_2 += 1
    end

    if is_day_up(first) && is_day_up(second) && is_day_up(third)
      @day_up_count_3 += 1
    end

    if is_day_up(first) && is_day_up(second) && is_day_up(third) && is_day_up(fourth)
      @day_up_count_4 += 1
    end

    if is_day_up(first) && is_day_up(second) && is_day_up(third) && is_day_up(fourth) && is_day_up(fifth)
      @day_up_count_5 += 1
    end

  end

  def is_day_up(quote)
    quote['open'] > quote['close']
  end

  def display
    puts "2 Days up #{@day_up_count_2} 3 Days up  #{@day_up_count_3} 4 Days up #{@day_up_count_4} 5 Days up #{@day_up_count_5}"
  end

end