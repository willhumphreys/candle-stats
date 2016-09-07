require 'rspec'
require_relative '../trade_results_processor'
require_relative '../trade_result'

describe 'My behaviour' do

  before do
    @trade_result_processor = TradeResultProcessor.new(10, 4)
  end

  it 'should do something' do

    trade_result = TradeResult.new(
        timestamp: DateTime.new(2007, 12, 5),
        direction: 'long',
        profit: 5
    )

    trade_on = @trade_result_processor.process_trade_result(trade_result, false, [], [] )

    expect(trade_on).to equal(false)

  end
end