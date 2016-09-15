
class TradeResult

  def initialize(timestamp: , direction: , profit:)

    @timestamp = timestamp
    @direction = direction
    @profit = profit
  end

  def is_not_a_loser
    profit >= 0
  end

  attr_reader :timestamp, :direction, :profit
end