require_relative '../up_days.rb'
require 'rspec'

describe 'My behaviour' do

  before do
    @up_days = UpDays.new
    # noinspection RubyStringKeysInHashInspection
    @first_quote = {'open' => 8, 'close' => 9}
    # noinspection RubyStringKeysInHashInspection
    @second_quote = { 'open' => 7, 'close' => 8}
  end

  it 'should increment the sequential counter if the two supplied quotes are up' do
    expect(@up_days.get_both_ticks_count).to equal(0)
    expect(@up_days.get_first_tick_count).to equal(0)

    @up_days.process(@first_quote, @second_quote)

    expect(@up_days.get_both_ticks_count).to equal(1)
    expect(@up_days.get_first_tick_count).to equal(1)

    expect(@up_days.get_sequential_percentage).to equal(100)

  end

  it 'should not increment the counter if the first quote is down but the second quote is up' do
    # noinspection RubyStringKeysInHashInspection
    @second_quote = { 'open' => 10, 'close' => 9}

    expect(@up_days.get_both_ticks_count).to equal(0)
    expect(@up_days.get_first_tick_count).to equal(0)

    @up_days.process(@first_quote, @second_quote)

    expect(@up_days.get_both_ticks_count).to equal(0)
    expect(@up_days.get_first_tick_count).to equal(1)

    expect(@up_days.get_sequential_percentage).to equal(0)
  end
end
