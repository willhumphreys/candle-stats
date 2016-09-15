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

    @trade_result_small = TradeResult.new(
        timestamp: DateTime.new(2007, 12, 5),
        direction: 'long',
        profit: 1
    )
  end

  it 'should return false when need a score of two but only score 1 ' do

    trade_result_processor = TradeResultProcessor.new(10, 2)

    trade_on = trade_result_processor.process_trade_result(@trade_result, false, [], [], 2)
    expect(trade_on).to equal(false)
  end

  it 'should return a winner if we have have the required_score and the next trade is above the minimum' do

    window_size = 2
    required_score = 2
    trade_result_processor = TradeResultProcessor.new(window_size, required_score)

    winners = []
    losers = []
    trade_on = trade_result_processor.process_trade_result(@trade_result, false, winners, losers, 2)
    expect(trade_on).to equal(false)
    expect(winners.empty?).to equal(true)
    expect(losers.empty?).to equal(true)

    trade_on = trade_result_processor.process_trade_result(@trade_result, false, winners, losers, 2)
    expect(trade_on).to equal(true)
    expect(winners.empty?).to equal(true)
    expect(losers.empty?).to equal(true)

    trade_on = trade_result_processor.process_trade_result(@trade_result, true, winners, losers, 2)
    expect(trade_on).to equal(true)
    expect(winners.size).to equal(1)
    expect(losers.empty?).to equal(true)
  end

  it 'should not trade if the we have enough trades but the next trade is not above the minimum level' do

    window_size = 2
    required_score = 1
    trade_result_processor = TradeResultProcessor.new(window_size, required_score)

    winners = []
    losers = []
    trade_on = trade_result_processor.process_trade_result(@trade_result, false, winners, losers, 2)
    expect(trade_on).to equal(true)
    expect(winners.empty?).to equal(true)
    expect(losers.empty?).to equal(true)

    trade_on = trade_result_processor.process_trade_result(@trade_result, true, winners, losers, 2)
    expect(trade_on).to equal(true)
    expect(winners.empty?).to equal(true)
    expect(losers.empty?).to equal(true)

    trade_on = trade_result_processor.process_trade_result(@trade_result_small, true, winners, losers, 2)
    expect(trade_on).to equal(true)
    expect(winners.empty?).to equal(true)
    expect(losers.empty?).to equal(true)
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

  it 'should store a winner' do
    trade_result_processor = TradeResultProcessor.new(6, 3)

    winners = []
    losers = []
    trade_result_processor.store_new_trade_result(winners, losers, @trade_result)

    expect(winners.size).to eq(1)
    expect(losers.empty?).to eq(true)
  end

  it 'should store a lose' do
    trade_result_processor = TradeResultProcessor.new(6, 3)

    winners = []
    losers = []
    trade_result_processor.store_new_trade_result(winners, losers, @trade_result_loss)

    expect(losers.size).to eq(1)
    expect(winners.empty?).to eq(true)
  end


end