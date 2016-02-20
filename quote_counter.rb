class QuoteCounter
  def initialize
    @quote_count = 0
  end

  def process(first, second)
    @quote_count += 1
  end

  def count
    @quote_count
  end

end
