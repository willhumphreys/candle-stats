require_relative 'bar_chart_quotes_mapper'

class BarChartFileRepo

  def initialize
    @bar_chart_quotes_mapper = BarChartQuotesMapper.new
  end

  def read_quotes
    file = File.read('EURGBP.json')
    data_hash = JSON.parse(file)
    quotes = data_hash['results']
    @bar_chart_quotes_mapper.map(quotes)
  end
end
