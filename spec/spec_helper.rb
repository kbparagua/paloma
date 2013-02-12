require 'rails'
require 'bundler/setup'
Bundler.require

require 'sample_app/init'
require 'rspec/rails'

require 'capybara/rspec'
require 'database_cleaner'


RSpec.configure do |config|
  config.before :each do
    DatabaseCleaner.strategy = :truncation
    DatabaseCleaner.start
  end

  config.after do
    DatabaseCleaner.clean
  end
end
