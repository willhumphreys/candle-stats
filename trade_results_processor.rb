require_relative 'trade_result_processor'

class TradeResultsProcessor

  def initialize(data_set, required_score, start_date, end_date, minimum_profit, window_size)
    @data_set = data_set
    @winners = []
    @losers = []

    @required_score = required_score
    @start_date = start_date
    @end_date = end_date
    @minimum_profit = minimum_profit
    @window_size = window_size

    @mt4_file_repo = MT4FileRepo.new(FadeMapper.new)

    @trade_result_processor = TradeResultProcessor.new(window_size, required_score)
  end

  public def process_trade_results(trade_results)
    puts @data_set

    trade_on = false

    trade_results.each { |trade_result|

      if trade_result.timestamp.utc < @start_date || trade_result.timestamp.utc > @end_date || trade_result.profit.abs < @minimum_profit
        next
      end

      trade_on = @trade_result_processor.process_trade_result(trade_result, trade_on, @winners, @losers)
    }

    if !@losers.empty? || !@winners.empty?

      winning_percentage = ((@winners.size.to_f / (@losers.size + @winners.size)) * 100).round(2)
      cut_off_percentage = ((@required_score.to_f / @window_size) * 100).round(2)

      puts @trade_result_processor.stored_trades.join('')

      Results.new(winning_percentage, cut_off_percentage, @winners, @losers)
    end
  end

end