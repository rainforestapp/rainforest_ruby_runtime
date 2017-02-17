# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rainforest_ruby_runtime/version'

Gem::Specification.new do |spec|
  spec.name          = "rainforest_ruby_runtime"
  spec.version       = RainforestRubyRuntime::VERSION
  spec.authors       = ["Simon Mathieu"]
  spec.email         = ["simon@rainforestqa.com"]
  spec.summary       = %q{Rainforest Ruby Runtime}
  spec.description   = %q{Rainforest Ruby Runtime}
  spec.homepage      = "https://www.rainforestqa.com/"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake"
  spec.add_dependency "sauce", "~> 3.7"
  spec.add_dependency "sauce-connect", "~> 3.6"
  spec.add_dependency "rspec-expectations", "~> 3.0"
  spec.add_dependency "capybara", "2.4.4"
  spec.add_dependency "selenium-webdriver", "2.53.4"
  spec.add_dependency "net-http-persistent", "2.9.4"
  spec.add_dependency "testingbot", "~> 0.1.5"
end
