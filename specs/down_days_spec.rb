require_relative '../down_days.rb'
require 'rspec'

describe 'My behaviour' do

  before do
    @down_days = DownDays.new
  end

  it 'should increment the counter if the two supplied quotes are down' do

    # noinspection RubyStringKeysInHashInspection
    first_quote = {'open' => 10, 'close' => 9}
    # noinspection RubyStringKeysInHashInspection
    second_quote = { 'open' => 9, 'close' => 8}

    expect(@down_days.count).to equal(0)

    @down_days.process(first_quote, second_quote)

    expect(@down_days.count).to equal(1)
  end
end
