# Author::    Matt Fornaciari (mailto:mattforni@gmail.com)
# License::   MIT

require 'active_support/core_ext/integer/time'

module Stocks
  # Provides an interface to do historical analysis of stocks.
  module Historical
    PERIODS = {
      one_month: {label: '1 Month', offset: 1.months},
      three_months: {label: '3 Months', offset: 3.months},
      six_months: {label: '6 Months', offset: 6.months},
      one_year: {label: '1 Year', offset: 1.years},
      five_years: {label: '5 Years', offset: 5.years}
    } # :nodoc:

    # Calculates the Moving Average Convergence Divergence.
    #
    # ===== *Args*
    # +symbol+ The symbol for which to calculate the MACD
    # +days+ The number of days for which to calculate the MACD
    # ===== *Returns*
    # An array of values for the number of days provided
    # ===== *Raises*
    # - +RetrievalError+ If the provided symbol does not exist
    def self.macd(symbol, days = DEFAULT_DAYS)
      sma12 = self.sma(symbol, 12, days)
      sma26 = self.sma(symbol, 26, days)
      (0...days).collect { |day| sma12[day] - sma26[day] }
    end

    # Calculates the Simple Moving Average.
    #
    # ===== *Args*
    # +symbol+ The symbol for which to calculate the SMA
    # +periods+ The number of periods to include in the average
    # +days+ The number of days for which to calculate the SMA
    # ===== *Returns*
    # An array of averages for the number of days provided
    # ===== *Raises*
    # - +RetrievalError+ If the provided symbol does not exist
    def self.sma(symbol, days = DEFAULT_DAYS, periods = DEFAULT_PERIODS)
      Stocks.exists!(symbol)

      sma = []
      (days <= 0 ? DEFAULT_DAYS : days).downto(1).each do |day|
        date = Date.today - day
        quotes = YahooFinance::get_HistoricalQuotes(symbol, date - (periods <= 0 ? DEFAULT_PERIODS : periods), date)
        sma << quotes.reduce(0) { |total, q| total += q.close } / quotes.size
      end
      sma
    end

    # Determines whether or not the provided symbol exists.
    #
    # ===== *Args*
    # +symbol+ The symbol for which to retrieve a quote
    # +period+ The period the quote should span
    # ===== *Returns*
    # A quote for the provided symbol over the provided period
    # ===== *Raises*
    # - +RetrievalError+ If the provided symbol does not exist
    # - +UnsupportedError+ If the provided period is not supported
    def self.quote(symbol, period)
      Stocks.exists!(symbol)
      raise UnsupportedError.new(period, PERIODS.keys) if !PERIODS.has_key?(period.try(:to_sym))

      YahooFinance::get_HistoricalQuotes(symbol, Date.today - PERIODS[period.to_sym][:offset], Date.today)
    end

    private

    DEFAULT_DAYS = 7 # :nodoc:
    DEFAULT_PERIODS = 7 # :nodoc:
  end
end

