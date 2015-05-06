# Author::    Matt Fornaciari (mailto:mattforni@gmail.com)
# License::   MIT

# Require external libraries
require 'yahoofinance'

# Require all Stocks related files
require 'stocks/errors'
require 'stocks/historical'
require 'stocks/validators/exists'

# TODO test this module
# TODO add a caching layer with 1-min TTL
module Stocks
  COMMISSION_RANGE = {greater_than_or_equal_to: 0}
  EPSILON = 0.00001
  NA = 'N/A'
  PRICE_RANGE = {greater_than: 0}
  PRICE_SCALE = 5
  PERCENTAGE_RANGE =  {greater_than: 0, less_than: 100}
  QUANTITY_RANGE = {greater_than: 0}

  # TODO move to another lib module
  def self.equal?(value, other)
    (value-other).abs < EPSILON
  end

  # Determines whether or not the provided symbol exists.
  #
  # * *Args*:
  #   - +symbol+ The symbol to evaluate
  # * *Returns*:
  #   - Whether or not the provided symbol exists
  def self.exists?(symbol)
    quote(symbol.upcase, [:date])[:date] != NA
  end

  # Fetches the last trade for the provided symbol.
  #
  # * *Args*:
  #   - +symbol+ The symbol to evaluate
  # * *Returns*:
  #   - The last trade for the provided symbol
  # * *Raises*:
  #   - +RetrievalError+ If the provided symbol does not exist
  def self.last_trade(symbol)
    last_trade = quote(symbol)[:lastTrade]
    raise RetrievalError.new("Could not retrieve last trade for '#{symbol}'") if last_trade == 0 or last_trade == NA
    last_trade
  end

  private

  def self.quote(symbol, fields = [:lastTrade])
    data = {}
    # TODO use the fields map to decide which method to use
    standard_quote = YahooFinance::get_standard_quotes(symbol)[symbol]
    fields.each do |field|
      data[field] = standard_quote.send(field) rescue NA
    end
    data
  end
end

