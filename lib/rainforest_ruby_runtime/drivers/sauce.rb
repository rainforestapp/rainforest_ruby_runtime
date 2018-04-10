module RainforestRubyRuntime
  module Drivers
    class Sauce
      attr_reader :options

      def initialize(options)
        @options = options
      end

      def call
        ::Sauce.config do |c|
          c[:browsers] = browsers
          c[:sauce_connect_4_executable] = 'vendor/sauce/sc'
        end
      end

      private

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
