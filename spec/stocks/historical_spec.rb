require 'spec_helper'

include Stocks
include YahooFinance

describe Historical do
  describe '::macd' do
    context 'when symbol is not valid' do
      it 'throws a RetrievalError' do
        # Arrange
        symbol = 'invalid'
        allow(Stocks).to receive(:exists?).and_return(false)
        
        # Act / Assert
        expect_retrieval_error(symbol) { Historical.macd(symbol)  }
      end
    end

    context 'when symbol is valid' do
      it 'returns an array of values' do
        # Arrange
        symbol = 'abc'
        days = Historical::DEFAULT_DAYS
        data = (0...days).map { 1 }
        allow(Stocks).to receive(:exists?).and_return(true)
        allow(Historical).to receive(:sma).with(symbol, 12, days).and_return(data.map { |d| d + 1 })
        allow(Historical).to receive(:sma).with(symbol, 26, days).and_return(data)
        
        # Act
        macd = Historical.macd(symbol, days)

        # Assert
        expect(macd.size).to eq(days)
        expect(macd).to eq(data)
      end
    end
  end

  describe '::sma' do
    context 'when symbol is not valid' do
      it 'throws a RetrievalError' do
        # Arrange
        symbol = 'invalid'
        allow(Stocks).to receive(:exists?).and_return(false)
        
        # Act / Assert
        expect_retrieval_error(symbol) { Historical.sma(symbol)  }
      end
    end

    context 'when days <= 0' do
      it 'sets days to DEFAULT_DAYS' do
        # Arrange
        symbol = 'abc'
        days = 0
        data = [HistoricalQuote.new(symbol, {close: 1})]
        allow(Stocks).to receive(:exists?).and_return(true)
        allow(YahooFinance).to receive(:get_HistoricalQuotes).and_return(data)
        
        # Act
        sma = Historical.sma(symbol)
        
        # Assert
        expect(sma.size).to eq(Historical::DEFAULT_DAYS)
      end
    end

    context 'when symbol is valid' do
      it 'returns an array of averages' do
        # Arrange
        symbol = 'abc'
        days = Historical::DEFAULT_DAYS
        data = [HistoricalQuote.new(symbol, {close: 1})]
        allow(Stocks).to receive(:exists?).and_return(true)
        allow(YahooFinance).to receive(:get_HistoricalQuotes).and_return(data)
        
        # Act
        sma = Historical.sma(symbol)
        
        # Assert
        expect(sma.size).to eq(days)
        expect(sma).to eq((0...days).map { data.first.close })
      end
    end
  end

  describe '::quote' do
    context 'when symbol is not valid' do
      it 'throws a RetrievalError' do
        # Arrange
        symbol = 'invalid'
        period = Historical::PERIODS.keys.first 
        allow(Stocks).to receive(:exists?).and_return(false)
        
        # Act / Assert
        expect_retrieval_error(symbol) { Historical.quote(symbol, period)  }
      end
    end

    context 'when period is not supported' do
      it 'throws an UnsupportedError' do
        # Arrange
        symbol = 'abc'
        period = :invalid 
        allow(Stocks).to receive(:exists?).and_return(true)
        
        # Act / Assert
        expect {
          Historical.quote(symbol, period)
        }.to raise_error(UnsupportedError, UnsupportedError.message(period, Historical::PERIODS.keys))
      end
    end

    context 'when symbol exists and period is supported' do
      it 'fetches a quote' do
        # Arrange
        symbol = 'abc'
        period = Historical::PERIODS.keys.first 
        allow(Stocks).to receive(:exists?).and_return(true)
        allow(YahooFinance).to receive(:get_HistoricalQuotes)
        
        # Act
        Historical.quote(symbol, period)

        # Assert
        expect(YahooFinance).to have_received(:get_HistoricalQuotes)
      end
    end
  end
end

