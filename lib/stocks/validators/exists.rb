# Author::    Matt Fornaciari (mailto:mattforni@gmail.com)
# License::   MIT

require 'active_model/validator'

module Stocks
  module Validators
    class Exists < ActiveModel::Validator

      def self.error_message(symbol)
        ERROR_MESSAGE % symbol
      end

      def validate(record)
        field = options[:symbol_field] || :symbol
        symbol = record.send(field)
        if (!Stocks.exists?(symbol))
          record.errors[field] << self.class.error_message(symbol)
        end
      end

      private

      ERROR_MESSAGE = '%s is not a valid ticker symbol.'
    end
  end
end

