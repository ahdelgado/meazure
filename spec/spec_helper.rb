# frozen_string_literal: true

require 'support/request_helpers'

RSpec.configure do |config|
  config.include Requests::JsonHelpers, type: :request
  config.silence_filter_announcements = true if ENV['TEST_ENV_NUMBER']
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
    expectations.on_potential_false_positives = :nothing
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.shared_context_metadata_behavior = :apply_to_host_groups
  config.filter_run_when_matching :focus
  config.disable_monkey_patching!

  config.default_formatter = 'doc' if config.files_to_run.one?

  config.order = :random
  config.expose_dsl_globally = true
  Kernel.srand config.seed

  config.before(:all) do
    Faker::UniqueGenerator.clear
  end
end
