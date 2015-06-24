require 'spec_helper'

include Stocks

describe Quote do
  describe '::quote' do
    context 'when type is not valid' do
      it 'raises an UnsupportedError' do
        # Arrange
        type = 'invalid'

        # Act / Assert
        expect_unsupported_error(type, Quote::TYPES.keys) { Quote.get('symbol', type) }
      end
    end

    context 'when symbol is not valid' do
      it 'returns an invalid quote' do
        # Arrange
        symbol = 'INVALID'
        struct = OpenStruct.new()
        struct.name = "N/A"
        response = {symbol: struct}
        allow(YahooFinance).to receive(:get_standard_quote).and_return(response)

        # Act / Assert
        expect(Quote.get(symbol)[symbol].valid?).to be_falsey
      end
    end

    context 'when symbol is valid' do
      it 'returns a quote' do
        # Arrange
        symbol = 'ABC'
        struct = OpenStruct.new()
        struct.name = "Symbol co."
        response = {symbol: struct}
        allow(YahooFinance).to receive(:get_standard_quote).and_return(response)

        # Act / Assert
        quote = Quote.get(symbol)[symbol]
        expect(quote).to be_a Quote
        expect(quote.valid?).to be_truthy
      end
    end

    context 'when there are multiple symbols' do
      it 'returns quotes for each' do
        # Arrange
        symbols = ['ABC', 'DEF']
        struct = OpenStruct.new()
        struct.name = "Symbol co."
        response = symbols.reduce({}) do |hash, symbol|
          hash[symbol] = struct
          hash
        end
        allow(YahooFinance).to receive(:get_standard_quote).and_return(response)

        # Act / Assert
        quotes = Quote.get(symbols)
        symbols.each { |symbol| expect(quotes[symbol]).to be_a Quote }
      end
    end
  end
end

