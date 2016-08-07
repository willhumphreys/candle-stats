class BackTestRow

  def initialize(date: , direction: , entry: , target_or_stop: , exit_date: , exit: , ticks: , cumulative_profit: )

    @date = date
    @direction = direction
    @entry = entry
    @target_or_stop = target_or_stop
    @exit_date = exit_date
    @exit = exit
    @ticks = ticks
    @cumulative_profit = cumulative_profit
  end

  attr_reader :date, :direction, :entry, :target_or_stop, :exit_date, :exit, :ticks, :cumulative_profit

end
