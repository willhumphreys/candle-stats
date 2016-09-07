
class TradeResultProcessor

  attr_reader :stored_trades

  def initialize(window_size, required_score)
    @required_score = required_score
    @window_size = window_size
    @stored_trades = []
  end

  def process_trade_result(trade_result, trade_on, winners, losers)
    if trade_on
      if @stored_trades.size >= @window_size
        if trade_result.profit >= 0
          winners.push(1)
        else
          losers.push(1)
        end
        trade_on = false
      end
    end

    if trade_result.profit > 0
      @stored_trades.push(1)
    else
      @stored_trades.push(-1)
    end

    if @stored_trades.size > @window_size
      @stored_trades = @stored_trades.drop(1)
    end

    stored_trades_score = @stored_trades.inject(0, :+)
    if (@required_score >= 0 && stored_trades_score >= @required_score) ||
        (@required_score < 0 && stored_trades_score <= @required_score)
      trade_on = true
    end

    trade_on
  end



end