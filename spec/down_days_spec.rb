require_relative '../down_days.rb'
require 'rspec'

describe 'My behaviour' do

  before do
    @down_days = DownDays.new
    # noinspection RubyStringKeysInHashInspection
    @first_quote = {'open' => 10, 'close' => 9}
    # noinspection RubyStringKeysInHashInspection
    @second_quote = { 'open' => 9, 'close' => 8}
  end

  it 'should increment the sequential counter if the two supplied quotes are down' do
    expect(@down_days.get_both_ticks_count).to equal(0)
    expect(@down_days.get_first_tick_count).to equal(0)

    @down_days.process(@first_quote, @second_quote)

    expect(@down_days.get_both_ticks_count).to equal(1)
    expect(@down_days.get_first_tick_count).to equal(1)

    expect(@down_days.calc_sequential_percentage).to equal(100)

  end

  it 'should not increment the counter if the first quote is down but the second quote is up' do
    # noinspection RubyStringKeysInHashInspection
    @second_quote = { 'open' => 9, 'close' => 10}

    expect(@down_days.get_both_ticks_count).to equal(0)
    expect(@down_days.get_first_tick_count).to equal(0)

    @down_days.process(@first_quote, @second_quote)

    expect(@down_days.get_both_ticks_count).to equal(0)
    expect(@down_days.get_first_tick_count).to equal(1)

    expect(@down_days.calc_sequential_percentage).to equal(0)
  end



end
