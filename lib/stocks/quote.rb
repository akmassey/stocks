# Author::    Matt Fornaciari (mailto:mattforni@gmail.com)
# License::   MIT

module Stocks
  # Reprsents an instance of a stock quote.
  class Quote < Hash
    # Mapping from base_quote type to YahooFinance method of retrieval
    # (options: :extended, :standard)
    TYPES = {
      'extended': :get_extended_quotes,
      'standard': :get_standard_quotes
    }

    # Fetches a quote for the provided symbols.
    #
    # ===== *Args*
    # - +symbols+ The symbols for which to retrieve a quote
    # - +type+ The type of quote to retreive (default: :standard)
    # ===== *Returns*
    # The quote for the provided symbol
    # ===== *Raises*
    # - +UnsupportedError+ If the provided type is not supported
    def self.get(symbols, type = :standard)
      raise UnsupportedError.new(type, Quote::TYPES.keys) if !Quote::TYPES.has_key?(type)

      symbols = [symbols] if !symbols.is_a?(Array)
      symbols = symbols.collect { |s| s.upcase }

      quotes = YahooFinance.send(Quote::TYPES[type], symbols)
      quotes.each_pair { |symbol, quote| quotes[symbol] = Quote.new(quote) }

      quotes
    end

    # :nodoc:
    def initialize(base_quote)
      @base_quote = base_quote
      get_fields.each { |field| self[field] = base_quote.send(field) } if valid?
    end

    # Determines whether or not the quote is valid.
    #
    # ===== *Returns*
    # Whether or not the quote is valid
    def valid?
      @base_quote.name != NOT_AVAILABLE
    end

    private

    attr_accessor :base_quote

    # :nodoc:
    def get_fields
      @base_quote.instance_variables.map { |f|
        f.to_s.gsub('@','').to_sym
      }.reject { |f_sym|
        !@base_quote.public_methods.include?(f_sym)
      }
    end
  end
end

