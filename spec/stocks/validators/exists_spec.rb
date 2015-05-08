require 'spec_helper'

include Stocks::Validators

# Arrange
FIELD = :symbol

class Migrations < ActiveRecord::Migration
  def self.positions
    drop_table :positions rescue nil
    create_table :positions do |t|
      t.string FIELD, null: false
    end
  end
end
Migrations.positions

class Position < ActiveRecord::Base
  validates_with Stocks::Validators::Exists, symbol_field: FIELD
end

# Tests
describe Exists do
  describe '#validate' do
    context 'when ticker symbol does not exist' do
      it 'fails validation and appends errors' do
        # Arrange
        symbol = 'invalid'
        allow(Stocks).to receive(:exists?).and_return(false)

        # Act
        position = Position.new({FIELD => symbol})

        # Assert
        expect(position.save).to be_false
        expect(position.errors).to_not be_empty
        expect(position.errors.size).to eq(1)
        expect(position.errors[FIELD]).to_not be_nil
        expect(position.errors[FIELD].first).to eq(Exists.message(symbol))
      end
    end

    context 'when ticker symbol does exist' do
      it 'validation passes and the record is saved' do
        # Arrange
        symbol = 'abc'
        allow(Stocks).to receive(:exists?).and_return(true)

        # Act
        position = Position.new({FIELD => symbol})

        # Assert
        expect(position.save).to be_true
        expect(position.errors).to be_empty
      end
    end
  end
end

