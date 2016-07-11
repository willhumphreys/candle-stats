require_relative '../high_take_out_and_hold'
require_relative '../quote.rb'
require 'rspec'

describe 'My behaviour' do

  before do
    @high_take_out_and_hold = HighTakeOutAndHold.new('AUDUSDWeekly')

    @first_quote = Quote.new('AUDUSD', '1234', '1', 5, 12, 4, 9, 10, 1)
    @second_quote = Quote.new('AUDUSD', '1234', '1', 7, 15, 3, 13, 10, 1)


  end

  it 'should increment the sequential counter if the two supplied quotes are up' do

    @high_take_out_and_hold.process(@first_quote, @second_quote)

    expect(@high_take_out_and_hold.high_closes_above_range).to equal(1)

    expect(@high_take_out_and_hold.high_total_close_above).to equal(1)
    expect(@high_take_out_and_hold.higher_high_count).to equal(1)

  end

  end