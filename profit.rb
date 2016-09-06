
class Profit

  def initialize(timestamp: , direction: , profit:)

    @timestamp = timestamp
    @direction = direction
    @profit = profit
  end

  attr_reader :timestamp, :direction, :profit
end