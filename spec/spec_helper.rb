require 'webmock/rspec'
require 'rspec/its'
require 'money'

RSpec::Matchers.define_negated_matcher :not_change, :change
WebMock.disable_net_connect!(allow_localhost: true)

def money(amount)
  Money.new(amount, 'USD')
end

RSpec.configure do |config|
  Dir["./spec/support/**/*.rb"].each {|f| require f}
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.shared_context_metadata_behavior = :apply_to_host_groups
  config.filter_run_when_matching :focus
  config.profile_examples = 3
  config.order = :random
end
