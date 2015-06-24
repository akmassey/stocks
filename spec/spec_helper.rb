require 'bundler/setup'
Bundler.setup

require 'active_record'
require 'stocks'

I18n.enforce_available_locales = false

RSpec.configure do |config|
end

ActiveRecord::Migration.verbose = false
ActiveRecord::Base.establish_connection(
  adapter:  'sqlite3',
  database: 'test.sqlite3',
  pool: 5,
  timeout: 5000
)

def expect_retrieval_error(symbol)
  expect { yield if block_given? }.to raise_error(RetrievalError, RetrievalError.message(symbol))
end

def expect_unsupported_error(provided, supported)
  expect { yield if block_given? }.to raise_error(UnsupportedError, UnsupportedError.message(provided, supported))
end

