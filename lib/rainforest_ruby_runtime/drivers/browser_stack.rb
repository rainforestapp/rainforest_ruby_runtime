require 'selenium/webdriver'

module RainforestRubyRuntime
  module Drivers
    class BrowserStack
      attr_reader :options

      def initialize(options)
        @options = options
      end

      def call
        url = "https://#{ENV['BROWSER_STACK_USERNAME']}:#{ENV['BROWSER_STACK_PASSWORD']}@hub.browserstack.com/wd/hub"
        capabilities = ::Selenium::WebDriver::Remote::Capabilities.new browsers.first
        capabilities['browserstack.debug'] = 'true'     

        ::Capybara.register_driver :browser_stack do |app|
          ::Capybara::Selenium::Driver.new(app, browser: :remote, url: url, desired_capabilities: capabilities) 
        end
      end

      private

      def browsers
        Array(options[:browsers]).map do |browser|
          { 
            "ie8" => {platform: "WINDOWS", browser: "internet explorer", browser_version: 8},
            "ie9" => {platform: "WINDOWS", browser: "internet explorer", browser_version: 9},
            "ie10" => {platform: "WINDOWS", browser: "internet explorer", browser_version: 10},
            "ie11" => {platform: "WINDOWS", browser: "internet explorer", browser_version: 11},
            "chrome" => {platform: "WINDOWS", browser: "googlechrome"},
            "firefox" => {platform: "WINDOWS", browser: "firefox", browser_version: 30.0},
            "safari" => {platform: "MAC", browser: "safari", browser_version: 7},
          }.fetch(browser)
        end
      end
    end
  end
end

Capybara.register_driver :browser_stack do |app|
end