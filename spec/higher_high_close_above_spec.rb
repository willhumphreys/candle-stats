require_relative '../higher_high_close_above'
require_relative '../quote.rb'
require 'rspec'

describe 'Higher high and close above tests' do

  before do
    @high_take_out_and_hold = HigherHighCloseAbove.new('AUDUSDWeekly')

    @first_quote = Quote.new('AUDUSD', '1234', '1', 5, 12, 4, 9, 10, 1)
    @second_quote = Quote.new('AUDUSD', '1234', '1', 7, 15, 3, 13, 10, 1)

  end

  it 'should calculate the difference in pips between the second quote and the first.' do
    expect(@high_take_out_and_hold.process(@first_quote, @second_quote)).to equal(30000)
  end

  end