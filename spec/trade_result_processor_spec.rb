require 'rspec'
require_relative '../trade_results_processor'
require_relative '../trade_result'

describe 'My behaviour' do

  before do
    @trade_result = TradeResult.new(
        timestamp: DateTime.new(2007, 12, 5),
        direction: 'long',
        profit: 5
    )

    @trade_result_loss = TradeResult.new(
        timestamp: DateTime.new(2007, 12, 5),
        direction: 'long',
        profit: -6
    )
  end

  it 'should return false when need a score of two but only score 1 ' do

    trade_result_processor = TradeResultProcessor.new(10, 2)

    trade_on = trade_result_processor.process_trade_result(@trade_result, false, [], [], 2)
    expect(trade_on).to equal(false)
  end

  it 'should return true when need a score of two and score 2 ' do

    trade_result_processor = TradeResultProcessor.new(10, 2)

    trade_on = trade_result_processor.process_trade_result(@trade_result, false, [], [], 2)
    expect(trade_on).to equal(false)

    trade_on = trade_result_processor.process_trade_result(@trade_result, false, [], [], 2)
    expect(trade_on).to equal(true)
  end

  it 'should return true when need a score of two and score 3 ' do
    trade_result_processor = TradeResultProcessor.new(10, 2)

    trade_on = trade_result_processor.process_trade_result(@trade_result, false, [], [], 2)
    expect(trade_on).to equal(false)

    trade_result_processor.process_trade_result(@trade_result, false, [], [], 2)
    trade_on = trade_result_processor.process_trade_result(@trade_result, false, [], [], 2)
    expect(trade_on).to equal(true)
  end

  it 'should return false when we are below the needed score, then true when we are the same and above and then false again when we fall below' do

    trade_result_processor = TradeResultProcessor.new(6, 3)

    trade_on = trade_result_processor.process_trade_result(@trade_result, false, [], [], 2)
    expect(trade_on).to equal(false)
    trade_on = trade_result_processor.process_trade_result(@trade_result, false, [], [], 2)
    expect(trade_on).to equal(false)
    trade_on = trade_result_processor.process_trade_result(@trade_result, false, [], [], 2)
    expect(trade_on).to equal(true)
    trade_on = trade_result_processor.process_trade_result(@trade_result, false, [], [], 2)
    expect(trade_on).to equal(true)
    trade_on = trade_result_processor.process_trade_result(@trade_result_loss, false, [], [], 2)
    expect(trade_on).to equal(true)
    trade_on = trade_result_processor.process_trade_result(@trade_result_loss, false, [], [], 2)
    expect(trade_on).to equal(false)
  end

end