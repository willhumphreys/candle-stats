require_relative '../higher_high_close_above'
require_relative '../quote.rb'
require 'rspec'

describe 'Higher high and close above tests' do

  before do
    @high_take_out_and_hold = HigherHighCloseAbove.new('AUDUSDWeekly')

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

  it 'should return the difference in pips if we put in a higher high and close above the previous high' do
    expect(@high_take_out_and_hold.process(@first_quote, @second_quote)).to equal(30000)
  end

  it 'should return nil if we do not put in a higher high' do

    @second_quote = Quote.new(
        symbol: 'AUDUSD',
        timestamp: '1234',
        trading_day: '1',
        open: 7,
        high: 7,
        low: 3,
        close: 13,
        volume: 10,
        open_interest: 1
    )

    expect(@high_take_out_and_hold.process(@first_quote, @second_quote)).to equal(nil)
  end

  it 'should return nil if we put in a higher high but do not close above it' do

    @second_quote = Quote.new(
        symbol: 'AUDUSD',
        timestamp: '1234',
        trading_day: '1',
        open: 7,
        high: 15,
        low: 3,
        close: 11,
        volume: 10,
        open_interest: 1
    )

    expect(@high_take_out_and_hold.process(@first_quote, @second_quote)).to equal(nil)
  end

  end