# Author::    Matt Fornaciari (mailto:mattforni@gmail.com)
# License::   MIT

# Require external libraries
require 'lrucache'
require 'yahoofinance'

# Require all Stocks related files
require 'stocks/errors'
require 'stocks/historical'
require 'stocks/validators/exists'

# Provides an interface to do real-time analysis of stocks.
module Stocks
  # Determines whether or not the provided symbol exists.
  #
  # ===== *Args*
  # - +symbol+ The symbol to evaluate for existence
  # ===== *Returns*
  # Whether or not the provided symbol exists
  def self.exists?(symbol)
    symbol.upcase!
    EXISTS_CACHE.fetch(symbol) { !quote(symbol, [:date])[:date].nil? }
  end

  # Raises an exception if the provided symbol does not exist.
  #
  # ===== *Args*
  # - +symbol+ The symbol to evaluate for existence
  # ===== *Raises*
  # - +RetrievalError+ If the provided symbol does not exist
  def self.exists!(symbol)
    raise RetrievalError.new(symbol) if !Stocks.exists?(symbol)
  end

  # Fetches the last trade for the provided symbol.
  #
  # ===== *Args*
  # - +symbol+ The symbol to evaluate
  # ===== *Returns*
  # The last trade for the provided symbol
  # ===== *Raises*
  # - +RetrievalError+ If the provided symbol does not exist
  def self.last_trade(symbol)
    last_trade = quote(symbol)[:lastTrade]
    raise RetrievalError.new(symbol) if last_trade.nil?
    last_trade
  end

  private

  EXISTS_CACHE = LRUCache.new(max_size: 500, ttl: 1.month) # :nodoc:

  def self.quote(symbol, fields = [:lastTrade])
    data = {}
    standard_quote = YahooFinance::get_standard_quotes(symbol)[symbol]
    fields.each do |field|
      data[field] = standard_quote.send(field) rescue nil
    end
    data
  end
end

