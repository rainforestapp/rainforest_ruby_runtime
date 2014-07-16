module RainforestRubyRuntime
  class Runner
    attr_reader :config_options

    def initialize(options = {})
      @config_options = options.dup.freeze
    end

    def run(code)
      extend RainforestRubyRuntime::DSL
      Capybara.default_driver = :"#{driver}"
      Capybara.default_wait_time = 20

      apply_config!

      test = eval(code)
      if Test === test
        test.run
      else
        raise WrongReturnValueError, test
      end
      test
    ensure
      terminate_session!
    end

    def extract_results(code)
      begin
        run(code)
      rescue RSpec::Expectations::ExpectationNotMetError => e
        return exception_to_payload e, status: 'failed'
      rescue RuntimeError => e
        return exception_to_payload e, status: 'error'
      rescue SyntaxError, Exception => e
        return exception_to_payload e, status: 'fatal_error'
      end

      {
        status: 'passed'
      }
    end

    def driver
      ENV.fetch("CAPYBARA_DRIVER") { "selenium" }
    end

    private
    def exception_to_payload(e, status: )
      {
        exception: e.class.to_s,
        message: e.message,
        status: status,
        backtrace: e.backtrace,
      }
    end

    def apply_config!
      config = {
        "selenium" => Drivers::Selenium,
        "sauce" => Drivers::Sauce,
      }.fetch(driver)

      config.new(config_options).call
    end

    def terminate_session!
      current_driver = Capybara.current_session.driver
      # Terminate the Sauce session if needed
      current_driver.finish! if current_driver.respond_to?(:finish!)
    end
  end
end
