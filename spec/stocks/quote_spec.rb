require 'spec_helper'

include Stocks

describe Quote do
  before(:all) do
    SYMBOL = 'ABC'
    SYMBOLS = [SYMBOL, 'DEF']
  end

  describe '::quote' do
    context 'when type is not valid' do
      it 'raises an UnsupportedError' do
        # Arrange
        type = 'invalid'

        # Act / Assert
        expect_unsupported_error(type, Quote::TYPES.keys) { Quote.get(SYMBOL, type) }
      end
    end

    context 'when symbol is not valid' do
      it 'returns an invalid quote' do
        # Arrange
        struct = OpenStruct.new()
        struct.name = 'N/A'
        response = {}
        response[SYMBOL] = struct
        allow(YahooFinance).to receive(:get_standard_quotes).and_return(response)

        # Act / Assert
        expect(Quote.get(SYMBOL)[SYMBOL].valid?).to be_falsey
      end
    end

    context 'when symbol is valid' do
      it 'returns a quote' do
        # Arrange
        struct = OpenStruct.new()
        struct.name = 'Symbol co.'
        response = {}
        response[SYMBOL] = struct
        allow(YahooFinance).to receive(:get_standard_quotes).and_return(response)

        # Act / Assert
        quote = Quote.get(SYMBOL)[SYMBOL]
        expect(quote).to be_a Quote
        expect(quote.valid?).to be_truthy
      end
    end

    context 'when there are multiple symbols' do
      it 'returns quotes for each' do
        # Arrange
        struct = OpenStruct.new()
        struct.name = "Symbol co."
        response = SYMBOLS.reduce({}) do |hash, symbol|
          hash[symbol] = struct
          hash
        end
        allow(YahooFinance).to receive(:get_standard_quotes).and_return(response)

        # Act / Assert
        quotes = Quote.get(SYMBOLS)
        SYMBOLS.each { |symbol| expect(quotes[symbol]).to be_a Quote }
      end
    end
  end
end

