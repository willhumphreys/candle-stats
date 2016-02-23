class CandleOperations
  def is_a_low_nearer(first, second)
    (first['low'] - second['open']).abs < (first['high'] - second['open']).abs
  end
  def is_high_nearer(first, second)
    (first['low'] - second['open']).abs > (first['high'] - second['open']).abs
  end
  def is_day_opening_in_range(first, second)
    second['open'] >= first['low'] && second['open'] <= first['high']
  end
  def is_a_lower_low_in(first, second)
    second['low'] < first['low']
  end
  def is_a_higher_high_in(first, second)
    second['high'] > first['high']
  end
  def is_a_down_day(quote)
    quote['close'] < quote['open']
  end
  def is_a_up_day(quote)
    quote['close'] > quote['open']
  end

  def full_candle_gaps(first, second)
    !(first['low']..first['high']).include?(second['open'])
  end

  def full_candle_gap_closes(first, second)
    #gap above #gapbelow
    (second['low'] <= first['high'] && second['open'] > first['high']) || (second['high'] >= first['low'] && second['open'] < first['low'])
  end

  def gaps(first, second)
    !(first['open']..first['close']).include?(second['open'])
  end

  def gap_closes(first, second)
    # code here
  end
end
