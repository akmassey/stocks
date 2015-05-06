# Author::    Matt Fornaciari (mailto:mattforni@gmail.com)
# License::   MIT

require 'active_support/core_ext/integer/time'

module Stocks
  module Historical
    PERIODS = {
      one_month: {label: '1 Month', offset: 1.months},
      three_months: {label: '3 Months', offset: 3.months},
      six_months: {label: '6 Months', offset: 6.months},
      one_year: {label: '1 Year', offset: 1.years},
      five_years: {label: '5 Years', offset: 5.years}
    }

    def self.macd(symbol, days)
      sma12 = self.sma(symbol, 12, days)
      sma26 = self.sma(symbol, 26, days)
      (0...days).collect { |day| sma12[day] - sma26[day] }
    end

    def self.sma(symbol, periods, days)
      sma = []
      days.downto(1).each do |day|
        date = Date.today - day
        quotes = YahooFinance::get_HistoricalQuotes(symbol, date - periods, date)
        sma << quotes.reduce(0) { |total, q| total += q.close } / quotes.size
      end
      sma
    end

    def self.quote(symbol, period)
      raise ArgumentError.new("Period must be provided for a historical quote") if period.nil?
      raise ArgumentError.new("'#{period}' is not a supported period") if !PERIODS.has_key?(period.to_sym)
      YahooFinance::get_HistoricalQuotes(symbol, Date.today - PERIODS[period.to_sym][:offset], Date.today)
    end
  end
end

