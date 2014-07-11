module RainforestRubyRuntime
  class Runner
    def self.run(code)
      extend RSpec::Matchers
      extend Capybara::DSL

      # Set up configuration
      Sauce.config do |c|
        c[:browsers] = [ ["Windows 7", "Firefox", "20"] ]
      end

      driver = ENV.fetch("CAPYBARA_DRIVER") { "selenium" }
      Capybara.default_driver = :"#{driver}"
      Capybara.default_wait_time = 20

      eval code
    end

    def self.extract_results(code)
      begin
        run(code)
      rescue RSpec::Expectations::ExpectationNotMetError => e
        return exception_to_payload e, status: 'failed'
      rescue RuntimeError => e
        return exception_to_payload e, status: 'error'
      rescue Exception => e
        return exception_to_payload e, status: 'fatal_error'
      end

      {
        status: 'passed'
      }
    end

    private
    def self.exception_to_payload(e, status: )
      {
          exception: e.class.to_s,
          message: e.message,
          status: status,
        }

    end
  end
end
