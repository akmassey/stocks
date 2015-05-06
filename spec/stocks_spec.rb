require 'spec_helper'

describe Stocks do
  describe '::exists?' do
    context 'when stock that does not exist' do
      it 'returns false' do
        expect(Stocks.exists?('invalid')).to be_false
      end
    end

    context 'when stock that does exist' do
      it 'returns true' do
        expect(Stocks.exists?('abc')).to be_true
      end
    end
  end

  describe '::last_trade' do
    context 'when stock does not exist' do
      it 'raises a RetrievalError' do
        expect { Stocks.last_trade('invalid') }.to raise_error(Stocks::RetrievalError) 
      end
    end

    context 'when stock does exist' do
      it 'returns a value greater than 0' do
        expect(Stocks.last_trade('abc') > 0).to be_true 
      end       
    end
  end
end

