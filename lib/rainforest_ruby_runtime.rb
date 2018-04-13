require "rainforest_ruby_runtime/process_monkey_patch"

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
  def self.platform
    case RUBY_PLATFORM
    when /cygwin|mswin|mingw|bccwin|wince|emx/ then :windows
    when /darwin/ then :osx
    else :linux
    end
  end

  def self.root
    File.dirname(__dir__)
  end

  def self.sc_executable_path
    if platform == :windows
      'vendor/sauce/sc.exe'
    else
      'vendor/sauce/sc'
    end
  end
end
