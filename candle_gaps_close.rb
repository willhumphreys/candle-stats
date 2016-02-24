require_relative 'candle_operations'

class CandleGapsClose
  def initialize(minimum_gap_size)
    @candle_operations = CandleOperations.new
    @candle_gap_count = 0
    @candle_gap_closed_count = 0
    @candle_count = 0
    @minimum_gap_size = minimum_gap_size
  end

  def process(first, second)
    @candle_count += 1

    if @candle_operations.gaps(first, second)
      @candle_gap_count += 1

      if @candle_operations.gap_closes(first, second, @minimum_gap_size)
        @candle_gap_closed_count += 1
        puts 'closed ' + first['tradingDay']
      else
        puts 'no close ' + first['tradingDay']
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
    puts "Total days #{@candle_count}. Minimum gap #{@minimum_gap_size}. Body candle gap count #{@candle_gap_count}."\
    " Closed candle gaps #{@candle_gap_closed_count}"
  end

end
