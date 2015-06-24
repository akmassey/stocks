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
        expect(Stocks.exists?('invalid')).to be_falsey
      end
    end

    context 'when symbol is valid' do
      it 'returns true' do
        # Arrange
        allow(Stocks).to receive(:quote).and_return({date: Date.today})

        # Act / Assert
        expect(Stocks.exists?('abc')).to be_truthy
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

end

