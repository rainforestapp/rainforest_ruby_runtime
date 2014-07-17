module RainforestRubyRuntime
  class Runner
    attr_reader :config_options

    def initialize(options = {})
      @config_options = options.dup.freeze
    end

    def run(code)
      extend RainforestRubyRuntime::DSL
      Capybara.default_driver = :"#{driver}"
      Capybara.default_wait_time = wait_time

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

    def extract_results(code, session_id: nil)
      stdout = stderr = nil
      payload = nil
      begin
        stdout, stderr = capture_output2 do
          run(code)
        end
      rescue RSpec::Expectations::ExpectationNotMetError => e
        payload = exception_to_payload e, status: 'failed'
      rescue RuntimeError => e
        payload = exception_to_payload e, status: 'error'
      rescue SyntaxError, Exception => e
        payload = exception_to_payload e, status: 'fatal_error'
      end

      payload ||= { status: 'passed' }

      payload.merge({
        stdout: stdout,
        stderr: stderr,
        session_id: session_id || self.session_id
      })
    end

    def driver
      ENV.fetch("CAPYBARA_DRIVER") { "selenium" }
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
    end

    def wait_time
      ENV.fetch("CAPYBARA_WAIT_TIME", 20).to_i
    end

    def session_id
      current_driver.browser.session_id if current_driver.browser.respond_to?(:session_id)
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
  end
end
