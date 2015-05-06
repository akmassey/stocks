# Author::    Matt Fornaciari (mailto:mattforni@gmail.com)
# License::   MIT

require 'active_model/validator'

module Stocks 
  module Validators
    class Exists < ActiveModel::Validator
      def validate(record)
        if (!Stocks.exists?(record.symbol))
          record.errors[:symbol] << "'#{record.symbol}' is not a valid symbol."
        end
      end
    end
  end
end

