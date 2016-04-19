require 'csv'
require_relative 'mt4_quote_mapper'

class MT4FileRepo

  @mt4_quote_mapper

  def initialize

    @mt4_quote_mapper = Mt4QuoteMapper.new

  end

  def read_quotes

    mapped_quotes = Array.new

    first_row = true

    file = 'data/EURJPY1440.csv'
    #file = 'data/USDCAD1440.csv'
    puts "Reading file #{file}"

    CSV.foreach(file) do |row|

      if first_row
        first_row = false
      else
        mapped_quotes.push(@mt4_quote_mapper.map(row))
      end



    end
    mapped_quotes
  end

end
