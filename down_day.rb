class DownDay

  def initialize
    @low_nearer = 0
  end

 def process(first, second)
   @low_nearer = is_a_down_day(first)
 end

  def is_a_down_day(quote)
    quote['close'] < quote['open']
  end

end
