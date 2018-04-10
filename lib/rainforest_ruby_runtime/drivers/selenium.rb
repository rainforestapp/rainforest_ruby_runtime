module RainforestRubyRuntime
  module Drivers
    class Selenium
      attr_reader :browsers

      def initialize(options)
        @browsers = options[:browsers]
      end

      def run(test)
        describe = RSpec.describe 'Rainforest', tests: [test], browsers: browsers do
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

        if ENV['RUNTIME_ENV'] == 'test'
          # if we're in tests, don't mix output from here with tests output
          # and don't include this describe block in the test count
          describe.run
          RSpec.world.example_groups.pop
        else
          RSpec.configure do |config|
            config.color = true
            config.formatter = :documentation
          end
          RSpec.configuration.reporter.report(RSpec.world.example_count([describe])) do |reporter|
            describe.run(reporter)
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
