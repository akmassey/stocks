# Author::    Matt Fornaciari (mailto:mattforni@gmail.com)
# License::   MIT

module Stocks
  class RetrievalError < RuntimeError
    def new(message)
      super(message)
    end
  end
end

