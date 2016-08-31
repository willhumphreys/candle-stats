require_relative 'profit'
require 'date'

class FadeMapper

  def initialize

  end

  def map(row)

    #2007-12-27T02:00,short,0.87368,stopped,2007-12-27T03:00,0.87472,-21

    date = DateTime.strptime("#{row[0]}", '%Y-%m-%dT%H:%M')

    Profit.new(
        timestamp: date,
        direction: row[1],
        profit: row[6].to_i,
        could_of_been_better: row[7].to_i
    )

  end
end
