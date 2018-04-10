module RainforestRubyRuntime
  module Drivers
    class Selenium
      attr_reader :browsers

      def initialize(options)
        @browsers = options[:browsers]
      end

      def to_rspec(test)
        RSpec.describe 'Rainforest', tests: [test], browsers: browsers do
          metadata[:tests].each do |test|
            describe "[#{test.id}] #{test.title}" do
              metadata[:browsers].each do |browser|
                let(:current_driver) { Capybara.current_session.driver }

                after do
                  if current_driver.respond_to?(:finish!)
                    current_driver.finish!
                  elsif current_driver.respond_to?(:quit)
                    current_driver.quit
                  end
                end

                specify browser do
                  # for whatever reason, this line no longer works if put in a `before` block
                  current_driver.options[:browser] = browser

                  test.run
                end
              end
            end
          end
        end
      end

      private

      def current_driver
        Capybara.current_session.driver
      end
    end
  end
end
