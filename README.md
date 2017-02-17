# Rainforest Ruby Runtime

[![Build Status](https://travis-ci.org/rainforestapp/rainforest_ruby_runtime.svg)](https://travis-ci.org/rainforestapp/rainforest_ruby_runtime)

Gem to run Rainforest Automated Tests locally or on Sauce Labs.

## Installation

Add this line to your application's Gemfile:

    gem 'rainforest_ruby_runtime'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install rainforest_ruby_runtime

## Usage

You can then run the tests using the following command:
```
bundle exec rainforest_test <test-file.rb>
```

To run the tests on Sauce Labs you should set the `SAUCE_USERNAME` and `SAUCE_ACCESS_KEY` environment variables.

## Contributing

1. Fork it ( https://github.com/rainforestapp/rainforest_ruby_runtime/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
