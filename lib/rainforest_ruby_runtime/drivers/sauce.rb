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
        end
      end

      private

      def browsers
        Array(options[:browsers]).map do |browser|
          {
            'ie8' => ["Windows 7", "Internet Explorer", "8"],
            'ie9' => ["Windows 7", "Internet Explorer", "9"],
            'ie10' => ["Windows 7", "Internet Explorer", "10"],
            'ie11' => ["Windows 7", "Internet Explorer", "11"],
            'chrome' => ["Windows 7", "Chrome", "35"],
            'firefox' => ["Windows 7", "Firefox", "30"],
            'safari' => ["Mavericks", "Safari", "7"],
          }.fetch(browser)
        end
      end
    end
  end
end

