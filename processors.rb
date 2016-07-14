require_relative 'candle_operations'
class Processors
  attr_reader :processors

  def initialize
    @candle_ops = CandleOperations.new

    higher_high_close_above_l = lambda do |first, second|
      if @candle_ops.is_a_higher_high_in(first, second) && @candle_ops.closes_above_range(first, second)
        return ((second.high - first.high) * 10000).round(0)
      end
      return nil
    end

    higher_high_close_inside_l = lambda do |first, second|
      if @candle_ops.is_a_higher_high_in(first, second) && @candle_ops.closes_inside_range(first, second)
        return ((second.high - first.high) * 10000).round(0)
      end
      nil
    end

    lower_low_close_below_l = lambda do |first, second|
      if @candle_ops.is_a_lower_low_in(first, second) && @candle_ops.closes_below_range(first, second)
        return ((second.low - first.low) * 10000).round(0)
      end
      return nil
    end

    lower_low_close_inside_l = lambda do |first, second|
      if @candle_ops.is_a_lower_low_in(first, second) && @candle_ops.closes_inside_range(first, second)
        return ((second.low - first.low) * 10000).round(0)
      end
      nil
    end

    @processors = {
        :higher_high_close_above => Processor.new('higher_high_close_above', higher_high_close_above_l),
        :higher_high_close_inside => Processor.new('higher_high_close_inside', higher_high_close_inside_l),
        :lower_low_close_below => Processor.new('lower_low_close_below', lower_low_close_below_l),
        :lower_low_close_inside => Processor.new('lower_low_close_inside', lower_low_close_inside_l)
    }
  end
end