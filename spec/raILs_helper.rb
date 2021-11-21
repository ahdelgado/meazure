# frozen_string_literal: true

# This file is copied to spec/ when you run 'rails generate rspec:install'
require 'spec_helper'
ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../config/environment', __dir__)
# Prevent database truncation if the environment is production
abort('The Rails environment is running in production mode!') if Rails.env.production?

Dir['./spec/support/**/*.rb'].sort.each { |f| require f }

require 'rspec/rails'
require 'api_helper'
require 'support/factory_bot'
require 'test_prof/recipes/rspec/let_it_be'

ActiveRecord::Migration.maintain_test_schema!

RSpec.configure do |config|
  config.fixture_path = "#{::Rails.root}/spec/fixtures"
  config.use_transactional_fixtures = true
  config.infer_spec_type_from_file_location!
  config.filter_rails_from_backtrace!
  if Bullet.enable?
    config.before(:each) { Bullet.start_request }
    config.after(:each)  { Bullet.end_request }
  end
end
