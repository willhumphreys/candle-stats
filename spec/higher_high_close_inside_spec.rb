require_relative '../higher_high_close_inside'
require_relative '../quote.rb'
require 'rspec'

describe 'Higher high and close inside tests' do

  before do
    @high_take_out_and_hold = HigherHighCloseInside.new('AUDUSDWeekly')

    @first_quote = Quote.new(
        symbol: 'AUDUSD',
        timestamp: '1234',
        trading_day: '1',
        open: 5,
        high: 12,
        low: 4,
        close: 9,
        volume: 10,
        open_interest: 1
    )

    @second_quote = Quote.new(
        symbol: 'AUDUSD',
        timestamp: '1234',
        trading_day: '1',
        open: 7,
        high: 15,
        low: 3,
        close: 13,
        volume: 10,
        open_interest: 1
    )
  end

  it 'should return nil if we do not put in a higher high' do
    @second_quote = Quote.new(
        symbol: 'AUDUSD',
        timestamp: '1234',
        trading_day: '1',
        open: 7,
        high: 10,
        low: 3,
        close: 13,
        volume: 10,
        open_interest: 1
    )

    expect(@high_take_out_and_hold.process(@first_quote, @second_quote)).to equal(nil)
  end

  it 'should return nil if we put in a higher high but still close outside.' do
    # 15 > 12
    expect(@high_take_out_and_hold.process(@first_quote, @second_quote)).to equal(nil)
  end

  it 'should return the difference between highs if we put in a higher high and close inside the range.' do

    @second_quote = Quote.new(
        symbol: 'AUDUSD',
        timestamp: '1234',
        trading_day: '1',
        open: 7,
        high: 16,
        low: 3,
        close: 11,
        volume: 10,
        open_interest: 1
    )

    #16 - 12
    expect(@high_take_out_and_hold.process(@first_quote, @second_quote)).to equal(40000)
  end

  end