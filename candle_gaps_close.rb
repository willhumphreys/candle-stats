require_relative 'candle_operations'

class CandleGapsClose
  def initialize(minimum_gap_size)
    @candle_ops = CandleOperations.new
    @candle_gap_count = 0
    @candle_gap_closed_count = 0
    @candle_count = 0
    @minimum_gap_size = minimum_gap_size
    @skipped_gap_count = 0
  end

  def process(first, second)
    @candle_count += 1

    if @minimum_gap_size == -1 || (first.close - second.open).abs >= @minimum_gap_size

      if @candle_ops.gaps(first, second)
        @candle_gap_count += 1

        if @candle_ops.gap_closes(first, second)
          @candle_gap_closed_count += 1
        end
      end
    else
      @skipped_gap_count += 1
    end
  end

  def get_gap_count
    @candle_gap_count
  end

  def gap_closed_count
    @candle_gap_closed_count
  end

  def display
    puts "Total days #{@candle_count}. Minimum gap #{@minimum_gap_size}. Body candle gap count #{@candle_gap_count}."\
    " Closed candle gaps #{@candle_gap_closed_count}. Skipped gaps #{@skipped_gap_count}"
  end

end
