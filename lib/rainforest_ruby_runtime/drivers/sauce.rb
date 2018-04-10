module RainforestRubyRuntime
  module Drivers
    class Sauce
      attr_reader :options

      def initialize(options)
        @options = options
      end

      def to_rspec(tests)
        apply_config

        RSpec.describe 'Rainforest', sauce: true, tests: tests do
          metadata[:tests].each do |test|
            it "[#{test.id}] #{test.title}" do
              test.run
            end
          end
        end
      end

      private

      def apply_config
        ::Sauce.config do |c|
          c[:browsers] = browsers
          c[:sauce_connect_4_executable] = 'vendor/sauce/sc'
        end
      end

      def browsers
        Array(options[:browsers]).map do |browser|
          {
            chrome: ['Windows 7', 'Chrome', 'latest'],
            firefox: ['Windows 7', 'Firefox', 'latest'],
            ie: ['Windows 7', 'Internet Explorer', 'latest'],
            edge: ['Windows 10', 'microsoftedge', 'latest'],
            safari: ['Mac 10.11', 'Safari', 'latest'],
          }.fetch(browser)
        end
      end
    end
  end
end
