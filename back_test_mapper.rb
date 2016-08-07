require_relative 'back_test_row'
require 'date'

class BackTestMapper

  def initialize

  end

  def map(row)

    date_time_format = '%Y-%m-%dT%H:%M:%S'

    BackTestRow.new(
        date: DateTime.strptime("#{row[0]}", date_time_format),
        direction: row[1],
        entry: row[2].to_f,
        target_or_stop: row[3],
        exit_date: DateTime.strptime("#{row[4]}", date_time_format),
        exit: row[5].to_f,
        ticks: row[6].to_i,
        cumulative_profit: row[7].to_i
    )

  end
end
