require 'spec_helper'

include Stocks

describe Stocks do
  before(:all) do
    SYMBOL = 'ABC'
  end

  before(:each) do
    Stocks::EXISTS_CACHE.clear
  end

  describe '::exists?' do
    context 'when symbol is not valid' do
      it 'returns false' do
        # Arrange
        response = {}
        response[SYMBOL] = {date: nil}
        allow(Quote).to receive(:get).and_return(response)

        # Act / Assert
        expect(Stocks.exists?(SYMBOL)).to be_falsey
      end
    end

    context 'when symbol is valid' do
      it 'returns true' do
        # Arrange
        response = {}
        response[SYMBOL] = {date: Date.today}
        allow(Quote).to receive(:get).and_return(response)

        # Act / Assert
        expect(Stocks.exists?(SYMBOL)).to be_truthy
      end
    end

    context 'when called more than once' do
      it 'caches the value' do
        # Arrange
        response = {}
        response[SYMBOL] = {date: Date.today}
        allow(Quote).to receive(:get).and_return(response)

        # Act
        Stocks.exists?(SYMBOL)
        Stocks.exists?(SYMBOL)

        # Assert
        expect(Quote).to have_received(:get).once
      end
    end
  end

  describe '::exists!' do
    context 'when symbol is not valid' do
      it 'raises a RetrievalError' do
        # Arrange
        allow(Stocks).to receive(:exists?).and_return(false)

        # Act / Assert
        expect_retrieval_error(SYMBOL) { Stocks.exists!(SYMBOL) }
      end
    end

    context 'when symbol is valid' do
      it 'does not raise a RetrievalError' do
        # Arrange
        response = {}
        response[SYMBOL] = {date: Date.today}
        allow(Quote).to receive(:get).and_return(response)

        # Act / Assert
        Stocks.exists!(SYMBOL)
      end
    end
  end

end

