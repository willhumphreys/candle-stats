require_relative '../candle_operations.rb'
require 'rspec'

describe 'candle entire overlap' do

  before do
    @candle_operations = CandleOperations.new
    # noinspection RubyStringKeysInHashInspection
    @first_quote = {'open' => 10, 'close' => 9, 'low' => 8, 'high' => 9}
    # noinspection RubyStringKeysInHashInspection
    @second_quote = {'open' => 12, 'close' => 9, 'low' => 8, 'high' => 13}
  end

  it 'should return true if the gap closes from above' do
    expect(@candle_operations.gap_closes(@first_quote, @second_quote)).to equal(true)
  end

  it 'should return true if the gap closes from below' do
    # noinspection RubyStringKeysInHashInspection
    @second_quote = {'open' => 7, 'close' => 9, 'low' => 5, 'high' => 10}
    expect(@candle_operations.gap_closes(@first_quote, @second_quote)).to equal(true)
  end

  it 'should return true if the gap closes from above with minimum gap' do
    expect(@candle_operations.gap_closes(@first_quote, @second_quote, 1)).to equal(true)
  end

  it 'should return true if the gap closes from below with minimum gap' do
    # noinspection RubyStringKeysInHashInspection
    @second_quote = {'open' => 7, 'close' => 9, 'low' => 5, 'high' => 10}
    expect(@candle_operations.gap_closes(@first_quote, @second_quote, 1)).to equal(true)
  end

  it 'should return false if the gap closes from above but gap is too small' do
    expect(@candle_operations.gap_closes(@first_quote, @second_quote, 5)).to equal(false)
  end

  it 'should return false if the gap closes from below but gap is too small' do
    # noinspection RubyStringKeysInHashInspection
    @second_quote = {'open' => 7, 'close' => 9, 'low' => 5, 'high' => 10}
    expect(@candle_operations.gap_closes(@first_quote, @second_quote, 5)).to equal(false)
  end


  it 'should return false if the above gap does not close' do
    # noinspection RubyStringKeysInHashInspection
    @second_quote = {'open' => 10, 'close' => 10, 'low' => 10, 'high' => 10}
    expect(@candle_operations.gap_closes(@first_quote, @second_quote)).to equal(false)
  end

  it 'should return false if the below gap does not close' do
    # noinspection RubyStringKeysInHashInspection
    @second_quote = {'open' => 5, 'close' => 5, 'low' => 5, 'high' => 5}
    expect(@candle_operations.gap_closes(@first_quote, @second_quote)).to equal(false)
  end
end