# Author::    Matt Fornaciari (mailto:mattforni@gmail.com)
# License::   MIT

require 'active_model/validator'

module Stocks 
  module Validators
    class Exists < ActiveModel::Validator
      ERROR_MESSAGE = '%s is not a valid ticker symbol.'

      def validate(record)
        field = options[:symbol_field] || :symbol
        symbol = record.send(field)
        if (!Stocks.exists?(symbol))
          record.errors[field] << ERROR_MESSAGE % symbol
        end
      end
    end
  end
end

