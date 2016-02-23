require_relative 'candle_operations'

class DoGapsClose
  def initialize
    @candle_operations = CandleOperations.new
    @gap_count = 0
    @gap_closed_count = 0
    @candle_count = 0
  end

  def process(first, second)
    @candle_count += 1

    if @candle_operations.full_candle_gaps(first, second)
      @gap_count += 1
      if @candle_operations.full_candle_gap_closes(first, second)
        @gap_closed_count += 1
      end
    end
  end

  def get_gap_count
    @gap_count
  end

  def gap_closed_count
    @gap_closed_count
  end

  def display
    puts "Total days #{@candle_count}. Total full candle gap count #{@gap_count}."\
    " Closed full candle gaps #{@gap_closed_count}"
  end

end