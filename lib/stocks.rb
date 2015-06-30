# Author::    Matt Fornaciari (mailto:mattforni@gmail.com)
# License::   MIT

# Require external libraries
require 'lrucache'
require 'yahoofinance'

# Require all Stocks related files
require 'stocks/errors'
require 'stocks/historical'
require 'stocks/quote'
require 'stocks/validators/exists'

# Provides an interface to do real-time analysis of stocks.
module Stocks
  NOT_AVAILABLE = 'N/A' # :nodoc:

  # Determines whether or not the provided symbol exists.
  #
  # ===== *Args*
  # - +symbol+ The symbol to evaluate for existence
  # ===== *Returns*
  # Whether or not the provided symbol exists
  def self.exists?(symbol)
    symbol.upcase!
    EXISTS_CACHE.fetch(symbol) { !Quote.get(symbol)[symbol][:date].nil? }
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

  private

  EXISTS_CACHE = LRUCache.new(max_size: 500, ttl: 1.month) # :nodoc:
end

