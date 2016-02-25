class DaysCloseSameDirection

  def initialize
    @tick_count = 0

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
  end

  def process(first, second, third, fourth, fifth, sixth)

    @tick_count += 1

    if is_day_up(first) && is_day_up(second)
      @day_up_count_2 += 1
    else
      @day_not_up_count_2 += 1
    end

    if is_day_up(first) && is_day_up(second) && is_day_up(third)
      @day_up_count_3 += 1
    else
      @day_not_up_count_3 += 1
    end

    if is_day_up(first) && is_day_up(second) && is_day_up(third) && is_day_up(fourth)
      @day_up_count_4 += 1
    else
      @day_not_up_count_4 += 1
    end

    if is_day_up(first) && is_day_up(second) && is_day_up(third) && is_day_up(fourth) && is_day_up(fifth)
      @day_up_count_5 += 1
    else
      @day_not_up_count_5 += 1
    end

    if is_day_up(first) && is_day_up(second) && is_day_up(third) && is_day_up(fourth) && is_day_up(fifth) && is_day_up(sixth)
      @day_up_count_6 += 1
    else
      @day_not_up_count_6 += 1
    end

  end

  def is_day_up(quote)
    quote['close'] > quote['open']
  end

  def day_up_percentage(day_up_count, day_not_up_count)
    ((day_up_count.to_f / (day_not_up_count + day_up_count)) * 100).round(2)
  end

  def display
    puts "Tick count #{@tick_count} 2 Days up #{@day_up_count_2} #{day_up_percentage(@day_up_count_2, @day_not_up_count_2)}%. "\
    "3 Days up  #{@day_up_count_3} #{day_up_percentage(@day_up_count_3, @day_not_up_count_3)}%. "\
    "4 Days up #{@day_up_count_4} #{day_up_percentage(@day_up_count_4, @day_not_up_count_4)}%. "\
    "5 Days up #{@day_up_count_5} #{day_up_percentage(@day_up_count_5, @day_not_up_count_5)}%. "\
    "6 Days up #{@day_up_count_6} #{day_up_percentage(@day_up_count_6, @day_not_up_count_6)}%. "
  end

end