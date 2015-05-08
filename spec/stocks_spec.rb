require 'spec_helper'

describe Stocks do
  before(:each) do
    Stocks::EXISTS_CACHE.clear
  end

  describe '::exists?' do
    context 'when symbol is not valid' do
      it 'returns false' do
        # Arrange
        allow(Stocks).to receive(:quote).and_return({date: nil})

        # Act / Assert
        expect(Stocks.exists?('invalid')).to be_false
      end
    end

    context 'when symbol is valid' do
      it 'returns true' do
        # Arrange
        allow(Stocks).to receive(:quote).and_return({date: Date.today})

        # Act / Assert
        expect(Stocks.exists?('abc')).to be_true
      end
    end

    context 'when called more than once' do
      it 'caches the value' do
        # Arrange
        allow(Stocks).to receive(:quote).and_return({date: Date.today})

        # Act
        Stocks.exists?('abc')
        Stocks.exists?('abc')

        # Assert
        expect(Stocks).to have_received(:quote).once
      end
    end
  end

  describe '::exists!' do
    context 'when symbol is not valid' do
      it 'raises a RetrievalError' do
        # Arrange
        symbol = 'invalid'
        allow(Stocks).to receive(:exists?).and_return(false)

        # Act / Assert
        expect_retrieval_error(symbol) { Stocks.exists!(symbol) }
      end
    end

    context 'when symbol is valid' do
      it 'does not raise a RetrievalError' do
        # Arrange
        symbol = 'abc'
        allow(Stocks).to receive(:quote).and_return({date: Date.today})

        # Act / Assert
        Stocks.exists!('abc')
      end
    end
  end

  describe '::last_trade' do
    context 'when symbol is not valid' do
      it 'raises a RetrievalError' do
        # Arrange
        symbol = 'invalid'
        allow(Stocks).to receive(:quote).and_return({lastTrade: nil})

        # Act / Assert
        expect_retrieval_error(symbol) { Stocks.last_trade(symbol) }
      end
    end

    context 'when symbol is valid' do
      it 'returns a value greater than 0' do
        # Arrange
        last_trade = 10
        allow(Stocks).to receive(:quote).and_return({lastTrade: last_trade})

        # Act / Assert
        expect(Stocks.last_trade('abc')).to eq(last_trade)
      end       
    end
  end
end

