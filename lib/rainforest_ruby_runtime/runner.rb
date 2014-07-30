module RainforestRubyRuntime
  class Runner
    attr_reader :config_options

    def initialize(options = {})
      @config_options = options.dup.freeze
      @step_variables = options[:step_variables]
      @callback = NilDelegator.new(options.fetch(:callback) { Empty.new })
    end

    def run(code)
      Capybara.default_driver = :"#{driver}"
      Capybara.default_wait_time = wait_time

      apply_config!
      setup_scope_registery!

      dsl = RainforestRubyRuntime::DSL.new(callback: @callback)

      test = dsl.run_code(code)
      if Test === test
        test.run
      else
        raise WrongReturnValueError, test
      end
      test
    ensure
      terminate_session!
    end

    def extract_results(code, fake_session_id: nil)
      stdout = stderr = nil
      payload = nil
      begin
        stdout, stderr = capture_output2 do
          run(code)
        end
      rescue RSpec::Expectations::ExpectationNotMetError => e
        payload = exception_to_payload e, status: 'failed'
      rescue StandardError => e
        payload = exception_to_payload e, status: 'error'
      rescue SyntaxError, Exception => e
        payload = exception_to_payload e, status: 'fatal_error'
      end

      payload ||= { status: 'passed' }

      payload.merge({
        stdout: stdout,
        stderr: stderr,
        session_id: fake_session_id || session_id
      })
    end

    def driver
      ENV.fetch("CAPYBARA_DRIVER") { "selenium" }
    end
    
    def current_browser
      current_driver.browser
    end

    def session_id
      current_browser.session_id if current_driver.browser.respond_to?(:session_id)
    end

    private
    def exception_to_payload(e, payload = {})
      payload.merge({
        exception: e.class.to_s,
        message: e.message,
        backtrace: e.backtrace,
      })
    end

    def apply_config!
      config = {
        "selenium" => Drivers::Selenium,
        "sauce" => Drivers::Sauce,
      }.fetch(driver)

      config.new(config_options).call
    end

    def current_driver
      Capybara.current_session.driver
    end

    def terminate_session!
      # Terminate the Sauce session if needed
      current_driver.finish! if current_driver.respond_to?(:finish!)
    rescue Selenium::WebDriver::Error::WebDriverError => e
      # Ignore
    end

    def wait_time
      ENV.fetch("CAPYBARA_WAIT_TIME", 20).to_i
    end

    def capture_output2
      previous_stdout, $stdout = $stdout, StringIO.new
      previous_stderr, $stderr = $stderr, StringIO.new
      yield
      [$stdout.string, $stderr.string]
    ensure
      # Restore the previous value of stdout (typically equal to STDERR).
      $stdout = previous_stdout
      $stderr = previous_stderr
    end

    def setup_scope_registery!
      # TODO this should not be set globally, but passed in the DSL
      if @step_variables.nil?
        Variables.scope_registery = Variables::Registery.new
      else
        Variables.scope_registery = Variables::StaticVariableRegistery.new(@step_variables)
      end
    end
  end
end
