# Author::    Matt Fornaciari (mailto:mattforni@gmail.com)
# License::   MIT

module Stocks
  # An error raised when data retrieval fails
  class RetrievalError < ArgumentError
    def initialize(symbol) # :nodoc:
      super(self.class.message(symbol))
    end

    # Generates the error message that is to be displayed.
    #
    # ===== *Args*
    # - +symbol+ The symbol to insert into the error message
    # ===== *Returns*
    # An error message representing the error
    def self.message(symbol)
      ERROR_MESSAGE % symbol
    end

    private

    ERROR_MESSAGE = "Unable to retrieve quote for '%s'" # :nodoc:
  end

  # An error raised when an unsupported value is provided
  class UnsupportedError < ArgumentError
    def initialize(provided, supported) # :nodoc:
      super(self.class.message(provided, supported))
    end

    # Generates the error message that is to be displayed.
    #
    # ===== *Args*
    # - +provided+ The value that was provided
    # - +provided+ A list of valid values
    # ===== *Returns*
    # An error message representing the error
    def self.message(provided, supported)
      ERROR_MESSAGE % [provided, supported.map { |s| "'#{s}'" }.join(', ')]
    end

    private

    ERROR_MESSAGE = "'%s' is not supported. Try %s" # :nodoc:
  end
end

