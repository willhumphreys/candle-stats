require_relative 'mt4_quote_mapper'

class Mt4QuotesMapper

  def initialize
    @mt4_quote_mapper = Mt4QuoteMapper.new
  end

  def map(quotes)
    mapped_quotes = Array.new

    quotes.each do |quote|
      mapped_quotes.push(@mt4_quote_mapper.map(quote))
    end
    mapped_quotes
  end
end
