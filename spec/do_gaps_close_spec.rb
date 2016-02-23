require_relative '../do_full_candle_gaps_close.rb'
require 'rspec'

describe 'gaps that close and do not' do

  before do
    @do_gaps_close = DoFullCandleGapsClose.new
    # noinspection RubyStringKeysInHashInspection
    @first_quote = {'open' => 10, 'close' => 9, 'low' => 8, 'high' => 9}
    # noinspection RubyStringKeysInHashInspection
    @second_quote = { 'open' => 9, 'close' => 8, 'low' => 8, 'high' =>9}
  end

  it 'gap counters should be 0 if there are no gaps' do

    @do_gaps_close.process(@first_quote, @second_quote)

    expect(@do_gaps_close.get_gap_count).to equal(0)
    expect(@do_gaps_close.gap_closed_count).to equal(0)
  end

  it 'gap counter should be 1 and closed count 0 if we have a gap that does not close' do
    # noinspection RubyStringKeysInHashInspection
    @second_quote = { 'open' => 12, 'close' => 12, 'low' => 11, 'high' => 13}

    @do_gaps_close.process(@first_quote, @second_quote)

    expect(@do_gaps_close.get_gap_count).to equal(1)
    expect(@do_gaps_close.gap_closed_count).to equal(0)
  end

  it 'gap counter should be 1 and closed count 1 if we have a down gap and it closes' do
    # noinspection RubyStringKeysInHashInspection
    @second_quote = { 'open' => 7, 'close' => 12, 'low' => 11, 'high' => 13}

    @do_gaps_close.process(@first_quote, @second_quote)

    expect(@do_gaps_close.get_gap_count).to equal(1)
    expect(@do_gaps_close.gap_closed_count).to equal(1)
  end


  it 'gap counter should be 1 and closed count 1 if we have a up gap and it closes' do
    # noinspection RubyStringKeysInHashInspection
    @second_quote = { 'open' => 5, 'close' => 8, 'low' => 4, 'high' => 8}

    @do_gaps_close.process(@first_quote, @second_quote)

    expect(@do_gaps_close.get_gap_count).to equal(1)
    expect(@do_gaps_close.gap_closed_count).to equal(1)
  end

end
