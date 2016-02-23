require 'rspec'

require_relative '../nearest_take_out'

describe 'The day opens in range' do
  before do
    @nearest_take_out = NearestTakeOut.new
    # noinspection RubyStringKeysInHashInspection
    @first_quote = {'open' => 10, 'close' => 9, 'low' => 7, 'high' => 11}
    # noinspection RubyStringKeysInHashInspection
    @second_quote = {'open' => 9, 'close' => 8, 'low' => 6, 'high' => 10}
  end

  it 'should increment count if next day opens in range' do
    @nearest_take_out.process(@first_quote, @second_quote)
    expect(@nearest_take_out.get_next_day_opens_range_count).to equal(1)
  end

  it 'should not increment count if next day does not open in range' do
    # noinspection RubyStringKeysInHashInspection
    @out_of_range_quote = {'open' => 3, 'close' => 8, 'low' => 6, 'high' => 10}

    @nearest_take_out.process(@first_quote, @out_of_range_quote)
    expect(@nearest_take_out.get_next_day_opens_range_count).to equal(0)
  end

end