require_relative '../candle_operations.rb'
require 'rspec'

describe 'candle entire overlap' do

  before do
    @candle_operations = CandleOperations.new
    # noinspection RubyStringKeysInHashInspection
    @first_quote = {'open' => 10, 'close' => 9, 'low' => 8, 'high' => 9}
    # noinspection RubyStringKeysInHashInspection
    @second_quote = {'open' => 100, 'close' => 110, 'low' => 90, 'high' => 120}
  end

  it 'should return true if the second candle is entirely above the first candle' do
    expect(@candle_operations.full_candle_gaps(@first_quote, @second_quote)).to equal(true)
  end

  it 'should return true if the second candle is entirely above the below candle' do
    # noinspection RubyStringKeysInHashInspection
    @second_quote = {'open' => 2, 'close' => 3, 'low' => 1, 'high' => 4}
    expect(@candle_operations.full_candle_gaps(@first_quote, @second_quote)).to equal(true)
  end

  it 'should return false if the second candle is overlaps the first candle' do
    # noinspection RubyStringKeysInHashInspection
    @second_quote = {'open' => 8, 'close' => 6, 'low' => 5, 'high' => 12}
    expect(@candle_operations.full_candle_gaps(@first_quote, @second_quote)).to equal(false)
  end
end

describe 'candle overlap' do
  before do
    @candle_operations = CandleOperations.new
    # noinspection RubyStringKeysInHashInspection
    @first_quote = {'open' => 10, 'close' => 9, 'low' => 8, 'high' => 9}
    # noinspection RubyStringKeysInHashInspection
    @second_quote = {'open' => 100, 'close' => 110, 'low' => 90, 'high' => 120}
  end

  it 'should return true if the second candle body is above the first candle body' do
    expect(@candle_operations.gaps(@first_quote, @second_quote)).to equal(true)
  end

  # noinspection RubyStringKeysInHashInspection
  @second_quote = {'open' => 1, 'close' => 1, 'low' => 1, 'high' => 1}

  it 'should return false if the second candle body is below the first candle body' do
    expect(@candle_operations.gaps(@first_quote, @second_quote)).to equal(true)
  end

  # noinspection RubyStringKeysInHashInspection
  @second_quote = {'open' => 10, 'close' => 11, 'low' => 8, 'high' => 12}

  it 'should return true if the second candle body overlaps the first candle body' do
    expect(@candle_operations.gaps(@first_quote, @second_quote)).to equal(true)
  end

end

