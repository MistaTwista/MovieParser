require 'rspec/its'
require 'factory_girl'
require 'ffaker'

RSpec.configure do |config|
  Dir["./spec/support/**/*.rb"].each {|f| require f}
  config.include FactoryGirl::Syntax::Methods

  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.before(:suite) do
    FactoryGirl.find_definitions
  end

  config.shared_context_metadata_behavior = :apply_to_host_groups
  config.filter_run_when_matching :focus
  config.profile_examples = 3
  config.order = :random
end
