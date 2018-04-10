$LOAD_PATH.unshift File.join(__dir__, "../lib")

require 'pry'
require 'awesome_print'
require 'rainforest_ruby_runtime'
require 'rspec'

ENV['RUNTIME_ENV'] = 'test'

RSpec.configure do |config|
  config.color = true
  config.formatter = :documentation

  config.before(show_output: true) do
    ENV['SHOW_OUTPUT'] = 'true'
  end
  config.after(show_output: true) do
    ENV.delete('SHOW_OUTPUT')
  end
end
