class DataSetProcessor



  def initialize(data_set, required_score, start_date, end_date, minimum_profit, window_size)
    @data_set = data_set
    @stored_trades = []
    @winners = []
    @losers = []
    @trade_on = false
    @required_score = required_score
    @start_date = start_date
    @end_date = end_date
    @minimum_profit = minimum_profit
    @window_size = window_size

    @output_directory = 'could_of_been_better_results'
    @input_directory = 'backtesting_data'
    @summary_file = "#{@output_directory}/summary_high_scores.csv"

    @mt4_file_repo = MT4FileRepo.new(FadeMapper.new)

  end


  public def process
    puts @data_set

    trade_results = @mt4_file_repo.read_quotes("#{@input_directory}/#{@data_set}.csv")


    trade_on = false

    trade_results.each { |trade_result|

      if trade_result.timestamp.utc < @start_date || trade_result.timestamp.utc > @end_date || trade_result.profit.abs < @minimum_profit
        next
      end

      if trade_on
        if @stored_trades.size >= @window_size
          if trade_result.profit >= 0
            @winners.push(1)
          else
            @losers.push(1)
          end
          trade_on = false
        end
      end

      if trade_result.profit > 0
        @stored_trades.push(1)
      else
        @stored_trades.push(-1)
      end

      if @stored_trades.size > @window_size
        @stored_trades = @stored_trades.drop(1)
      end

      stored_trades_score = @stored_trades.inject(0, :+)
      if (@required_score >= 0 && stored_trades_score >= @required_score) ||
          (@required_score < 0 && stored_trades_score <= @required_score)
        trade_on = true
      end
    }

    if !@losers.empty? || !@winners.empty?

      winning_percentage = ((@winners.size.to_f / (@losers.size + @winners.size)) * 100).round(2)
      cut_off_percentage = ((@required_score.to_f / @window_size) * 100).round(2)
      puts "#{@start_date}-#{@end_date} #{@data_set } minimum_profit: #{@minimum_profit} cut off: #{@required_score} "\
               "moving average count: #{@window_size} winners: #{@winners.size} losers: #{@losers.size} "\
               "#{winning_percentage}% cut off percentage: #{cut_off_percentage}"
      puts @stored_trades.join('')

      open(@summary_file, 'a') { |f|
        f << "#{@start_date},#{@end_date},#{@data_set},#{@minimum_profit},#{@required_score},#{@window_size},"\
                 "#{@winners.size},#{@losers.size},#{winning_percentage},#{cut_off_percentage}\n"
      }
    end

  end

end