# frozen_string_literal: true

ENV['RAILS_ENV'] ||= 'test'
if ENV['COVERAGE'] == '1'
  require 'simplecov'
  SimpleCov.start 'rails'
end
require_relative '../config/environment'
require 'rails/test_help'

module ActiveSupport
  class TestCase
    include FactoryBot::Syntax::Methods

    # Run tests in parallel with specified workers
    parallelize(workers: ENV['COVERAGE'] == '1' ? 1 : :number_of_processors)

    # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
    fixtures :all

    # Add more helper methods to be used by all tests here...
  end
end
