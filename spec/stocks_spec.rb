require 'spec_helper'

describe Stocks do
  describe '::exists?' do
    context 'when stock that does not exist' do
      it 'returns false' do
        # Arrange
        allow(Stocks).to receive(:quote).and_return({date: Stocks::NA})

        # Act / Assert
        expect(Stocks.exists?('invalid')).to be_false
      end
    end

    context 'when stock that does exist' do
      it 'returns true' do
        # Arrange
        allow(Stocks).to receive(:quote).and_return({date: Date.today})

        # Act / Assert
        expect(Stocks.exists?('abc')).to be_true
      end
    end
  end

  describe '::last_trade' do
    context 'when stock does not exist' do
      it 'raises a RetrievalError' do
        # Arrange
        allow(Stocks).to receive(:quote).and_return({lastTrade: Stocks::NA})

        # Act / Assert
        expect { Stocks.last_trade('invalid') }.to raise_error(Stocks::RetrievalError) 
      end
    end

    context 'when stock does exist' do
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

