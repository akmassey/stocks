# Author::    Matt Fornaciari (mailto:mattforni@gmail.com)
# License::   MIT

module Stocks
  module Validators
    # An ActiveRecord validator which validates that an attribute on a model is a
    # valid ticker symbol. The default attribute is +:symbol+ but may be specified
    # by defining +symbol_field+ when declaring the validator.
    #
    # Example Usage:
    #
    #   require 'stocks/validators/exists'
    #
    #   class Position < ActiveRecord::Base
    #     validates_with Stocks::Validators::Exists, symbol_field: :field_name
    #   end
    class Exists < ActiveModel::Validator

      # Generates the error message that is inserted into +record.errors+.
      #
      # ===== *Args*
      # - +symbol+ The symbol to insert into the error message
      # ===== *Returns*
      # An error message representing the validation failure
      def self.message(symbol)
        ERROR_MESSAGE % symbol
      end

      # Validates that a record have a valid symbol.
      #
      # ===== *Args*
      # - +record+ The record to validate
      def validate(record)
        field = options[:symbol_field] || :symbol
        symbol = record.send(field)
        if (!Stocks.exists?(symbol))
          record.errors[field] << self.class.message(symbol)
        end
      end

      private

      ERROR_MESSAGE = '%s is not a valid ticker symbol.' # :nodoc:
    end
  end
end

