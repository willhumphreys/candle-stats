
class Profit

  def initialize(timestamp: , direction: , profit: , could_of_been_better:)

    @timestamp = timestamp
    @direction = direction
    @profit = profit
    @could_of_been_better = could_of_been_better
  end

  attr_reader :timestamp, :direction, :profit, :could_of_been_better
end