require_relative 'candle_operations'

class DoGapsClose
  def initialize
    @candle_operations = CandleOperations.new
  end

  def process(first, second)

    if @candle_operations.gaps(first,second)
      @candle_operations.gap_closes(first, second)
    end

  end


end