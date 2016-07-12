require_relative 'quote'
require 'date'

class Mt4QuoteMapper

  def initialize

  end

  def map(row)

    date = DateTime.strptime("#{row[0]} #{row[1]}", '%Y.%m.%d %H:%M')

    Quote.new(
        symbol: '',
        timestamp: date,
        trading_day: row[0],
        open: row[2].to_f,
        high: row[3].to_f,
        low: row[4].to_f,
        close: row[5].to_f,
        volume: row[6].to_i,
        open_interest: 0
    )

  end
end
