require_relative '../quote_counter'
require 'rspec'

describe QuoteCounter do

  before do
    @quote_counter = QuoteCounter.new
  end

  it 'has a count an initial count of 0' do
    expect(@quote_counter.count).to equal(0)
  end
end
