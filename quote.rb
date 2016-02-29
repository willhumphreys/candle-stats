class Quote

  # "symbol": "^EURGBP",
  #     "timestamp": "2015-02-19T00:00:00-06:00",
  #     "tradingDay": "2015-02-19",
  #     "open": 0.7381,
  #     "high": 0.74086,
  #     "low": 0.73574,
  #     "close": 0.73735,
  #     "volume": 277112,
  #     "openInterest": null

  def initialize(symbol, timestamp, trading_day, open, high, low, close, volume, open_interest)

    @symbol = symbol
    @timestamp = timestamp
    @trading_day = trading_day
    @open = open
    @high = high
    @low = low
    @close = close
    @volume = volume
    @open_interest = open_interest
  end

  attr_reader :symbol, :timestamp, :trading_day, :open, :high, :low, :close, :volume, :open_interest

end
