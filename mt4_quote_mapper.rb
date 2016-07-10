require_relative 'quote'
require 'date'

class Mt4QuoteMapper

  def initialize

  end

  def map(row)

    date = DateTime.strptime("#{row[0]} #{row[1]}", '%Y.%m.%d %H:%M')

    Quote.new('', date, row[0], row[2].to_f, row[3].to_f, row[4].to_f, row[5].to_f, row[6].to_i, 0)
  end

end
