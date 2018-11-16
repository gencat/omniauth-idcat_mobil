# frozen_string_literal: true

require "bundler/setup"
require "rspec"
require "rack/test"
require "omniauth"
require "omniauth/test"
require "omniauth/idcat_mobil"

RSpec.configure do |config|
  config.include Rack::Test::Methods
  config.extend OmniAuth::Test::StrategyMacros, type: :strategy
  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end