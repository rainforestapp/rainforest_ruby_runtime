require "sauce"
require "sauce/capybara"
require "rspec/expectations"
require "logger"

require "rainforest_ruby_runtime/version"
require "rainforest_ruby_runtime/exceptions"
require "rainforest_ruby_runtime/test"
require "rainforest_ruby_runtime/empty"
require "rainforest_ruby_runtime/nil_delegator"
require "rainforest_ruby_runtime/dsl"
require "rainforest_ruby_runtime/runner"
require "rainforest_ruby_runtime/drivers/sauce"
require "rainforest_ruby_runtime/drivers/selenium"
require "rainforest_ruby_runtime/variables/value"
require "rainforest_ruby_runtime/variables/registry"
require "rainforest_ruby_runtime/variables/scope"

module RainforestRubyRuntime
  def self.root
    File.dirname(__dir__)
  end
end
