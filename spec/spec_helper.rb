$LOAD_PATH.unshift File.join(__dir__, "../lib")

require 'pry'
require 'awesome_print'
require 'rainforest_ruby_runtime'
require 'rspec'

ENV['RUNTIME_ENV'] = 'test'
