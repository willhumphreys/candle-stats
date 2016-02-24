require_relative 'candle_operations'

class CandleGapsClose
  def initialize
    @candle_operations = CandleOperations.new
    @full_candle_gap_count = 0
    @full_candle_gap_closed_count = 0
    @candle_count = 0
  end

  def process(first, second, *minimum_gap_size)
    @candle_count += 1

    if @candle_operations.gaps(first, second)
      @full_candle_gap_count += 1
      if @candle_operations.gap_closes(first, second)
        @full_candle_gap_closed_count += 1
      end
    end
  end

  def get_gap_count
    @full_candle_gap_count
  end

  def gap_closed_count
    @full_candle_gap_closed_count
  end

  def display
    puts "Total days #{@candle_count}. Body candle gap count #{@full_candle_gap_count}."\
    " Closed candle gaps #{@full_candle_gap_closed_count}"
  end

end
