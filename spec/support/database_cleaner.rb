# This database_cleaner configure for a special case when you want to clean test database after the test run.
# If the app itself can auto wipe out test database then we don't need to require this file.

require 'yaml'
require 'database_cleaner'
require 'active_record'

@environment = 'test'
@dbconfig = YAML.load(File.read('config/database.yml'))
ActiveRecord::Base.establish_connection @dbconfig[@environment]

DatabaseCleaner.allow_production = true
DatabaseCleaner.allow_remote_database_url = true

RSpec.configure do |config|

  config.before(:each) do
    DatabaseCleaner.strategy = :transaction
  end

  config.before(:each, type: :feature) do
    driver_shares_db_connection_with_specs = Capybara.current_driver == :rack_test

    unless driver_shares_db_connection_with_specs
      DatabaseCleaner.strategy = :truncation
    end
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.append_after(:each) do
    DatabaseCleaner.clean
  end
end
