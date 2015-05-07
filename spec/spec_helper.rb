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

