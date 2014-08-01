module RainforestRubyRuntime
  module Drivers
    class TestingBot
      attr_reader :options

      def initialize(options)
        @options = options
      end

      def call
        ::TestingBot.config do |c|
          c[:desired_capabilities] = browsers
        end
      end

      private

      def browsers
        Array(options[:browsers]).map do |browser|
          {
            "ie8" => {platform: "WINDOWS", browserName: "internet explorer", version: 8, idletimeout: 90},
            "ie9" => {platform: "WINDOWS", browserName: "internet explorer", version: 9, idletimeout: 90},
            "ie10" => {platform: "WINDOWS", browserName: "internet explorer", version: 10, idletimeout: 90},
            "ie11" => {platform: "WINDOWS", browserName: "internet explorer", version: 11, idletimeout: 90},
            "chrome" => {platform: "XP", browserName: "googlechrome", idletimeout: 90},
            "firefox" => {platform: "XP", browserName: "firefox", version: 30.0, idletimeout: 90},
            "safari" => {platform: "MAC", browserName: "safari", version: 7, idletimeout: 90},
          }.fetch(browser)
        end
      end
    end
  end
end

