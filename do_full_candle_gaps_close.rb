require_relative 'candle_operations'

class DoFullCandleGapsClose
  def initialize
    @candle_ops = CandleOperations.new
    @candle_gap_count = 0
    @candle_gap_closed_count = 0
    @candle_count = 0
  end

  def process(first, second)
    @candle_count += 1

    if @candle_ops.full_candle_gaps(first, second)
      @candle_gap_count += 1
      if @candle_ops.full_candle_gap_closes(first, second)
        @candle_gap_closed_count += 1
      end
    end
  end

  def get_gap_count
    @candle_gap_count
  end

  def gap_closed_count
    @candle_gap_closed_count
  end

  def display
    puts "Total days #{@candle_count}. Total full candle gap count #{@candle_gap_count}."\
    " Closed full candle gaps #{@candle_gap_closed_count}"
  end

end
